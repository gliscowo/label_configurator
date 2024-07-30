import 'dart:convert';
import 'dart:io';

import 'package:github/github.dart';

import 'config.dart';

Future<void> main(List<String> arguments) async {
  final github = GitHub(auth: Authentication.withToken(File("gh_token").readAsLinesSync().first));

  final config = Config.fromJson(jsonDecode(File("labels.json").readAsStringSync()) as Map<String, dynamic>);

  if (arguments.isEmpty) {
    print("Repository slug must be provided as first argument");
    exit(-1);
  }

  final repo = RepositorySlug.full(arguments.first);
  print("Working on repository $repo");

  for (final label in config.labels) {
    print(" - Label '${label.name}'");
    var existingLabel = await _getLabel(github, repo, label.name);
    if (existingLabel == null && label.from != null) existingLabel = await _getLabel(github, repo, label.from!);

    if (existingLabel != null) {
      if (label.matches(existingLabel)) {
        print("   Already correct, skipping");
        continue;
      }

      await github.patchJSON(
        "/repos/$repo/labels/${label.name != existingLabel["name"] ? label.from : label.name}",
        body: GitHubJson.encode({
          "color": label.color,
          if (label.from != null && existingLabel["name"] != label.name) "new_name": label.name,
          if (label.description != null) "description": label.description,
        }),
      );

      print("   Updated");
    } else {
      await github.postJSON(
        "/repos/$repo/labels",
        body: GitHubJson.encode({
          "name": label.name,
          "color": label.color,
          "description": label.description,
        }),
      );

      print("   Created");
    }
  }

  if (config.deleteLabels.isNotEmpty) {
    print("");
    print("Deleting unused labels");

    for (final label in config.deleteLabels) {
      print(" - Label '$label'");

      await github.issues.deleteLabel(repo, label);
      print("   Deleted");
    }
  }

  github.client.close();
}

Future<Map<String, dynamic>?> _getLabel(GitHub github, RepositorySlug repo, String name) async {
  try {
    return await github.getJSON("/repos/$repo/labels/$name",
        convert: (dynamic i) => i as Map<String, dynamic>, statusCode: StatusCodes.OK);
  } catch (_) {
    return null;
  }
}
