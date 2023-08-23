# *Omniverse Kit* Project Template

This project is a template for developing apps and extensions for *Omniverse Kit*.

[Documentation](https://docs.omniverse.nvidia.com/kit/docs/kit-project-template)

# Getting Started

1. Fork and clone this repo, for example in `C:\projects\kit-project-template`
2. (Optional) Open this cloned repo using Visual Studio Code: `code C:\projects\kit-project-template`. It will suggest installing a few extensions to improve python experience.
3. In the terminal (CTRL + \`) run `pull_kit_kernel.bat` (windows) / `pull_kit_kernel.sh` (linux) to pull the *Omniverse Kit Kernel*. `kit` folder link will be created.
4. Run an example app that includes example extensions: `source/apps/my_name.my_app.bat` (windows) / `./source/apps/my_name.my_app.sh` (linux).

The first start will take a while as it will pull all the extensions from the extension registry and build various caches. Subsequent starts will be much faster.

## An Omniverse App

If you look inside a `source/apps/my_name.my_app.bat` or any other *Omniverse App*, they all run *Omniverse Kit* . *Omniverse Kit* (`kit.exe`) is the Omniverse Application runtime that powers *Apps* build out of extensions.
Think of it as `python.exe`. It is a small runtime, that enables all the basics, like settings, python, logging and searches for extensions. **Everything else is an extension.** 

To start an app we pass a `kit` file, which itself is a single file extension. It describes which extensions to pull and load, which settings to apply. One kit file fully desribes an app.

Notice that it includes `omni.hello.world` extension, that is a part of this repo. All the other extensions are pulled from the extension registry on first startup.

More info on building kit files: [doc](https://docs.omniverse.nvidia.com/kit/docs/kit-manual/latest/guide/creating_kit_apps.html)

### Packaging an App

To package an app run `tools/package.bat` (or `repo package`). The package will be created in the `_build/packages` folder.

To use the package, unzip and run `pull_kit_kernel.bat` inside the package once before running the app.

### Version Lock

App `kit` file fully defines all the extensions, but their versions are not locked. By default latest versions will be used. Also, many extensions would bring many other extensions as their dependencies.

However, for the final app it is important that it will will always get the same extensions and the same versions on each run. It provides reliable and reproducible build. This is called a *version lock* and we have a separate section at the end of `kit` file to lock versions of all extensions and all their dependencies.

It is important to update the version lock section when adding new extensions or updating existing ones. To update version look `precache_exts` tool is used.

**To update version lock run:** `tools/update_version_lock.bat`. 

Commit any changes to a kit file.

Packaging tool will verify that version lock exist and fail if it doesn't.

More info on dependency management: [doc](https://docs.omniverse.nvidia.com/kit/docs/kit-manual/latest/guide/creating_kit_apps.html#application-dependencies-management)

## An Omniverse Extension

This template includes one simple extension: `omni.hello.world`. It is loaded in the example app, but can also be loaded and tested in any other *Omniverse App*.

### Using Omniverse Launcher

1. Install *Omniverse Launcher*: [download](https://www.nvidia.com/en-us/omniverse/download)
2. Install and launch one of *Omniverse* apps in the Launcher. For instance: *Code*.

### Add a new extension to your *Omniverse App*

If you want to add extensions from this repo to your other existing Omniverse App.

1. In the *Omniverse App* open extension manager: *Window* &rarr; *Extensions*.
2. In the *Extension Manager Window* open a settings page, with a small gear button in the top left bar.
3. In the settings page there is a list of *Extension Search Paths*. Add cloned repo `source/extensions` subfolder there as another search path: `C:/projects/kit-project-template/source/extensions`

![Extension Manager Window](/images/add-ext-search-path.png)

4. Now you can find `omni.hello.world` extension in the top left search bar. Select and enable it.
5. "My Window" window will pop up. *Extension Manager* watches for any file changes. You can try changing some code in this extension and see them applied immediately with a hotreload.

### Few tips

* Now that `source/extensions` folder was added to the search you can add new extensions to this folder and they will be automatically found by the *App*.
* Look at the *Console* window for warnings and errors. It also has a small button to open current log file.
* All the same commands work on linux. Replace `.bat` with `.sh` and `\` with `/`.
* Extension name is a folder name in `source/extensions`, in this example: `omni.hello.world`. 
* Most important thing extension has is a config file: `extension.toml`, take a peek.
* In the *Extensions* window, press *Bread* button near the search bar and select *Show Extension Graph*. It will show how the current *App* comes to be: all extensions and dependencies.
* Extensions system documentation can be found [here](https://docs.omniverse.nvidia.com/kit/docs/kit-manual/latest/guide/extensions_advanced.html)

### Alternative way to add a new extension

To get a better understanding and learn a few other things, we recommend following:

1. Run bare `kit.exe` with `source/extensions` folder added as an extensions search path and new extension enabled:

```bash
> kit\kit.exe --ext-folder source/extensions --enable omni.hello.world
```

- `--ext-folder [path]` - adds new folder to the search path
- `--enable [extension]` - enables an extension on startup.

Use `-h` for help:

```bash
> kit\kit.exe -h
```

2. After the *App* started you should see:
    * new "My Window" window popup.
    * extension search paths in *Extensions* window as in the previous section.
    * extension enabled in the list of extensions.

It starts much faster and will only have extensions enabled that are required for this new extension (look at  `[dependencies]` section of `extension.toml`). You can enable more extensions: try adding `--enable omni.kit.window.extensions` to have extensions window enabled (yes, extension window is an extension too!):

```bash
> kit\kit.exe --ext-folder source/extensions --enable omni.hello.world --enable omni.kit.window.extensions
```

You should see a menu in the top left. From here you can enable more extensions from the UI. 


# Running Tests

To run tests we run a new process where only the tested extension (and it's dependencies) is enabled. Like in example above + testing system (`omni.kit.test` extension). There are 2 ways to run extension tests:

1. Run: `tools\test_ext.bat omni.hello.world`

That will run a test process with all tests and exit. For development mode pass `--dev`: that will open test selection window. As everywhere, hotreload also works in this mode, give it a try by changing some code!

2. Alternatively, in *Extension Manager* (*Window &rarr; Extensions*) find your extension, click on *TESTS* tab, click *Run Test*

For more information about testing refer to: [testing doc](http://omniverse-docs.s3-website-us-east-1.amazonaws.com/kit-sdk/104.0/docs/guide/ext_testing.html).


# Adding a new extension

Adding a new extension is as simple as copying and renaming existing one:

1. copy `source/extensions/omni.hello.world` to `source/extensions/[new extension name]`
2. rename python module (namespace) in `source/extensions/[new extension name]/omni/hello/world` to `source/extensions/[new extension name]/[new python module]`
3. update `source/extensions/[new extension name]/config/extension.toml`, most importantly specify new python module to load:

```toml
[[python.module]]
name = "[new python module]"
```

No restart is needed, you should be able to find and enable `[new extension name]` in extension manager.

# Sharing extensions

To make extension available to other users use [Github Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository).

1. Make sure the repo has [omniverse-kit-extension](https://github.com/topics/omniverse-kit-extension) topic set for auto discovery.
2. For each new release increment extension version (in `extension.toml`) and update the changelog (in `docs/CHANGELOG.md`). [Semantic versionning](https://semver.org/) must be used to express severity of API changes.

# Contributing

The source code for this repository is provided as-is and we are not accepting outside contributions.

# License

By using this solution you agree to the terms of this [License](LICENSE) . The most recent version of the License is available [here](https://docs.omniverse.nvidia.com/composer/latest/common/NVIDIA_Omniverse_License_Agreement.html).