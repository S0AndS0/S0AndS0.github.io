---
layout: post
title: "Node Actions"
date: 2019-08-22 14:58:05 -0700
categories: gha github actions node
---


**`.github/workflows/main.yml`**


```YAML
name: 'Test Inputs'
description: 'Tests GitHub Actions inputs parsing options'

inputs:
  test_string:
    description: 'Test string input of Actions'
    default: 'Spam Slam'
    required: true

runs:
  using: 'node12'
  main: lib/test-env-inputs.js
```


The documentation on [`inputs`][gha__actions__inputs] states that the IDs are **up-cased** and prefixed with **`INPUT_`**, and documentation on [`workflows`][gha__configure_workflow] states that `with:` is how inputs are assigned by ID when included within `jobs:`.


**`lib/test-env-inputs.js`**


```JavaScript
console.log(`process.env.INPUT_TEST_STRING -> ${process.env.INPUT_TEST_STRING}`);

console.log('process.env...');
console.table(process.env);
```


**`.github/actions/test-inputs/action.yml`**


```YAML
on: push

jobs:
  one:
    runs-on: ubuntu-16.04
    steps:
      - name: First tests
        uses: S0AndS0/gha-tests/.github/actions/test-inputs@master
        with:
          test_string: 'Ham Fan?'
```


Action files are named `action.yml` thus organizing in separate repositories or subdirectories is required.


The above `uses:` line's syntax `<author|organization>`**`/`**`<repository>`**`/`**`<path>`**`@`**`<branch|reference>` was used (though documentation eludes to using relative paths being an option), because errors are more _on point_ when debugging an action.



**Example Log**


The [logs][test_inputs__log_example] should show something similar to the following. Most note worthy will the final value of `test_string`/`INPUT_TEST_STRING`...


```
.env.test_string -> Ham Fan?

________________________________________________________________________________________________________________________________________
      VCPKG_INSTALLATION_ROOT      |                                      '/usr/local/share/vcpkg'
             ANT_HOME              |                                          '/usr/share/ant'
              GOROOT               |                                         '/usr/local/go1.12'
             JAVA_HOME             |                                  '/usr/lib/jvm/zulu-8-azure-amd64'
         JAVA_HOME_11_X64          |                                 '/usr/lib/jvm/zulu-11-azure-amd64'
          GITHUB_ACTIONS           |                                               'true'
            GRADLE_HOME            |                                         '/usr/share/gradle'
          GOROOT_1_10_X64          |                                         '/usr/local/go1.10'
         JAVA_HOME_12_X64          |                                 '/usr/lib/jvm/zulu-12-azure-amd64'
            RUNNER_USER            |                                              'runner'
            BOOST_ROOT             |                                   '/usr/local/share/boost/1.69.0'
          JAVA_HOME_7_X64          |                                  '/usr/lib/jvm/zulu-7-azure-amd64'
     PERFLOG_LOCATION_SETTING      |                                          'RUNNER_PERFLOG'
         RUNNER_TOOL_CACHE         |                                       '/opt/hostedtoolcache'
          GOROOT_1_11_X64          |                                         '/usr/local/go1.11'
         BOOST_ROOT_1_69_0         |                                   '/usr/local/share/boost/1.69.0'
             LEIN_JAR              |                 '/usr/local/lib/lein/self-installs/leiningen-2.9.1-standalone.jar'
          JAVA_HOME_8_X64          |                                  '/usr/lib/jvm/zulu-8-azure-amd64'
               LANG                |                                            'en_US.UTF-8'
           ImageVersion            |                                               '156.2'
              M2_HOME              |                                   '/usr/share/apache-maven-3.6.1'
               PATH                | '/usr/share/rust/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin'
           ANDROID_HOME            |                                    '/usr/local/lib/android/sdk'
        DEPLOYMENT_BASEPATH        |                                            '/opt/runner'
          RUNNER_PERFLOG           |                                       '/home/runner/perflog'
             LEIN_HOME             |                                        '/usr/local/lib/lein'
               HOME                |                                           '/home/runner'
               CONDA               |                                       '/usr/share/miniconda'
               USER                |                                              'runner'
 DOTNET_SKIP_FIRST_TIME_EXPERIENCE |                                                 '1'
          GOROOT_1_12_X64          |                                         '/usr/local/go1.12'
         ANDROID_SDK_ROOT          |                                    '/usr/local/lib/android/sdk'
          GOROOT_1_9_X64           |                                         '/usr/local/go1.9'
        RUNNER_TRACKING_ID         |                            'github_90e782bb-15c3-4d41-a541-90d39f33f200'
            CHROME_BIN             |                                      '/usr/bin/google-chrome'
         INPUT_TEST_STRING         |                                             'Ham Fan?'
            GITHUB_REF             |                                         'refs/heads/master'
            GITHUB_SHA             |                             '57c0813746f0fb5673e6ea76459bc551bd3946f4'
         GITHUB_REPOSITORY         |                                         'S0AndS0/gha-tests'
           GITHUB_ACTOR            |                                              'S0AndS0'
          GITHUB_WORKFLOW          |                                    '.github/workflows/main.yml'
          GITHUB_HEAD_REF          |                                                 ''
          GITHUB_BASE_REF          |                                                 ''
         GITHUB_EVENT_NAME         |                                               'push'
         GITHUB_WORKSPACE          |                               '/home/runner/work/gha-tests/gha-tests'
           GITHUB_ACTION           |                                         'S0AndS0gha-tests'
         GITHUB_EVENT_PATH         |                        '/home/runner/work/_temp/_github_workflow/event.json'
             RUNNER_OS             |                                               'Linux'
            RUNNER_TEMP            |                                      '/home/runner/work/_temp'
         RUNNER_WORKSPACE          |                                    '/home/runner/work/gha-tests'
________________________________________________________________________________________________________________________________________
```


[gha__actions__inputs]: https://help.github.com/en/articles/metadata-syntax-for-github-actions#inputs

[gha__configure_workflow]: https://help.github.com/en/articles/configuring-a-workflow

[test_inputs__log_example]: https://github.com/S0AndS0/gha-tests/commit/5999dea0d64d3974c4b7ff47e481832e2b2a57cd/checks
