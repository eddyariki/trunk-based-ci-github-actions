# Trunk Based Gitops CI Actions Example

This is an example of how we can use tags to automate CI while using trunk based development.

The basic flow is like this:

```mermaid
flowchart TD
    A(Main Branch)
    B(Feature Branch Created)
    C{PR Submitted}
    D[GitHub Actions Runs]
    E{Check Latest Commit Message & Tag}
    F{Increment Version STG/DEV}
    F2{Increment Version STG/DEV}
    G1[Create Tag vx.x.x-dev-hash]
    G2[Create Tag vx.x.x-stg-hash]
    H{New Commit Added to PR}
    I{PR Merged}
    J[GitHub Actions Runs Different]
    K{Check Commit Message of Merge & Tag}
    L[Create Tag vx.x.x]

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G1
    F --> G2
    C -->|New Commit Added| H
    H --> D
    C -->|PR Merged| I
    I --> J
    J --> K
    K --> F2
    F2 --> L
```

This means that every PR will automatically create tags for dev and stg environments using semantic versioning.
To increment MAJOR, your commit message must include `MAJOR`. This is the same for MINOR and PATCH.

The base version will be the main tagged latest tag.

Only when the PR is merged to main will it create the production tag that does not include any environment label or commit hash.


## Usecase
A CICD pipeline where CloudBuild is triggered based on tags and you want to separate Dev and Stg environments.
- You want to auto deploy to Dev and/or Stg during development. You plan to control the Stg deployment by adding an approval flow, so you want to separate Dev and Stg pipelines.
- You want to use semantic versioning without manual tagging.
