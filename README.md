#  Flutter Boiler Plate App 

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

---

## Getting Started 🚀

This project contains 3 configuration flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --target lib/main_development.dart

# Staging
$ flutter run --target lib/main_staging.dart

# Production
$ flutter run --target lib/main_production.dart
```

_\*App works on iOS, Android._

### Launch Configuration for VSCode/Android Studio

### VSCode

- File Path: `.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch development",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_development.dart",
      "args": ["--target", "lib/main_development.dart"
      ]
    },
    {
      "name": "Launch staging",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_staging.dart",
      "args": ["--target", "lib/main_staging.dart"]
    },
    {
      "name": "Launch production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_production.dart",
      "args": ["--target", "lib/main_production.dart"]
    }
  ]
}
```

### Android Studio

- File Path: `.idea/runConfigurations/development.xml`

```xml
<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="development" type="FlutterRunConfigurationType" factoryName="Flutter">
    <option name="filePath" value="$PROJECT_DIR$/lib/main_development.dart" />
    <method v="2" />
  </configuration>
</component>
```

- File Path: `.idea/runConfigurations/staging.xml`

```xml
<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="staging" type="FlutterRunConfigurationType" factoryName="Flutter">
    <option name="filePath" value="$PROJECT_DIR$/lib/main_staging.dart" />
    <method v="2" />
  </configuration>
</component>
```

- File Path: `.idea/runConfigurations/production.xml`

```xml
<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="production" type="FlutterRunConfigurationType" factoryName="Flutter">
    <option name="filePath" value="$PROJECT_DIR$/lib/main_production.dart" />
    <method v="2" />
  </configuration>
</component>
```

[coverage_badge]: coverage_badge.svg
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
