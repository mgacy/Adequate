<a href="https://apps.apple.com/us/app/adequate/id1438986355"><img src=".github/header-light.png"  alt="Adequate for iOS"></a></p>

Adequate is a free and open-source iOS client for the [Meh](https://meh.com) daily deals website.

## Building

### 1. Configure Backend

Clone the backend from [Adequate-Backend](https://github.com/mgacy/Adequate-Backend) and deploy following the directions in the project's `README`.

```bash
git clone https://github.com/mgacy/Adequate-Backend.git
```

### 2. Clone Project

```bash
git clone https://github.com/mgacy/Adequate.git
```

### 3. Install tools and dependencies

Adequate uses the following tools:

- [Cocoapods](https://github.com/CocoaPods/CocoaPods)
- [Sourcery](https://github.com/krzysztofzablocki/Sourcery)
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)

If have not already installed Sourcery and SwiftGen, the `bootstrap.sh` script will install them using [Homebrew](https://brew.sh). 

Run:

```bash
sh bootstrap.sh
```

### 4. Configuration

Add the configuration files for the development, staging, and production environments:

```
ProjectDirectory/
  buildscripts/
    env_configs/
      awsconfiguration-dev.json
      awsconfiguration-prod.json
      awsconfiguration-stg.json
```

Add credentials for the SwiftyBeaver [platform](https://docs.swiftybeaver.com/article/11-log-to-swiftybeaver-platform) as well as the ARNs for your AWS SNS platform applications and SNS topics to `/buildscripts/env-vars.sh`.


## Acknowledgements

- [CoordinatorKit](https://github.com/imaccallum/CoordinatorKit)


## License

Distributed under the [MIT](https://choosealicense.com/licenses/mit/) License.
