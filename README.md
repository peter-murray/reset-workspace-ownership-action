# reset-workspace-ownership-action

A GitHub Action that can be utilized to reset ownership on directories and files in the `GITHUB_WORKSPACE` that can result from 
using Containers in GitHub Actions Workflows on self-hsoted runners.


## Problem

When using self-hosted runners with GitHub Actions the action runners have a persistence across workflow jobs and workflows that
can sometime be tripped up by using containers as part of your workflows.

Any container that outputs files or directories will create them within the `GITHUB_WORKSPACE` directory with the owner set to that
of the `USER` in the container that being executed unless you are performing a user and/or group remapping when starting the container.

Typically this can result in files being present inside the `GITHUB_WORKSPACE` directory that are owned by `root` and it is not common to
be running the GitHub Actions runner as the root user (you can do so, but it is discouraged).

When you then execute another workflow on the repository that has some of the files present in the `GITHUB_WORKSPACE` you will typically encounter
a problem with the `actions/checkout@v2` action failing as it cannot clean up the `GITHUB_WORKSPACE` directory at the beginning of the following
workflow execution.


## A Workaround Solution

To resolve this problem and prevent it from breaking a future workflow invocation, you can utilize the action to detect and correct the directories 
and files that are not currently owned by the same user that the GitHub Actions runner is running as.

This GitHub Action is a Docker based Action that will mount the `GITHUB_WORKSPACE` and then look for any directories or files not owned by the specifed
user UID and then change the ownership to the provided UID.

To do this it uses the smallest possible container with a bash environment to be able to detect and fix these ownership issues so as to not add much overhead
to any workflow executions. It has to be a Docker container, as it runs as `root` inside the container to be able to perform these ownership changes.


## Parameters

* `user_id`: The UID of the user that the GitHub Actions runner is running as. This will be the UID that will be used to modify any files or directories
  that do not currently have this UID as the owner. This needs to be a UID number and not a name, as the container will not necessarily have a user inside it
  that will resolve to a valid user.

Note that you need to already know the UID for the GitHub Actions runner, or be able to reference it from the environment. You cannot do this as part of this 
action, as this action is Docker based and does not have access to the runner's environment when it runs.

You can utilize an action step like the following to expose the UID of the GitHub Actions runner so it can be referenced as an Action Step Output:

```
- name: Get Actions user id
  id: get_uid
  run: |
    actions_user_id=`id -u $USER`
    echo $actions_user_id
    echo ::set-output name=uid::$actions_user_id
```


## Examples

Obtain the UID of the GitHub Actions runner and then correct any directories and files that are not owned by the runner.

```
- name: Get Actions user id
  id: get_uid
  run: |
    actions_user_id=`id -u $USER`
    echo $actions_user_id
    echo ::set-output name=uid::$actions_user_id

- name: Correct Ownership in GITHUB_WORKSPACE directory
  uses: peter-murray/reset-workspace-ownership-action@v1
  with:
    user_id: ${{ steps.get_uid.outputs.uid }}
```

## Action Logs

When the action is run it will log the files adn directories it detects as not being owned by the provided UID and will show before and 
after listing of the file:

```

```