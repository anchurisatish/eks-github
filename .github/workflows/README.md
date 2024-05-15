# Github Actions

## What is GitHub Actions?

GitHub Actions is a platform that helps automate various tasks for developers. One common task it automates is Continuous Integration/Continuous Deployment (CI/CD), but it can do much more than that. It helps simplify and streamline tasks that are time-consuming or prone to errors for developers.

## Why do we need another CI/CD tool?

GitHub Actions provides an all-in-one solution for CI/CD, eliminating the need for third-party tools and making integration with code repositories seamless. Its setup process is straightforward and tailored specifically for developers.

## How is it better than Jenkins?

GitHub Actions offers native integration with popular tools and services, making configuration simpler and more cost-effective. Instead of manually installing and configuring various tools, you can define your requirements in a clear and concise way, such as specifying the need for Node.js and Docker, and deploying to a specific cloud environment.

## GitHub Hosted Runners and Self-hosted Runners

GitHub Actions supports both GitHub-hosted runners and self-hosted runners. GitHub-hosted runners are provided by GitHub and are available for use with public repositories as well as private repositories. Self-hosted runners are machines that you manage and configure yourself, giving you more control over your execution environment.
Public repositories https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners#standard-github-hosted-runners-for-public-repositories

Private Repositories https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners#standard-github-hosted-runners-for-private-repositories 

## Actions and Workflows

Actions are individual tasks or steps that make up a workflow. Workflows are automated processes defined in YAML format, consisting of one or more actions. You can have multiple workflows for different purposes, such as building and testing pull requests, deploying applications, or managing issues. Workflows are triggered by various events, both internal (like code pushes or pull requests) and external (like scheduled times or manual triggers). You can define workflows in the .github/workflows directory of your repository.
Workflow Syntax for GitHub Actions
The syntax for defining workflows in GitHub Actions is straightforward and well-documented. You can define workflows to be triggered by specific events, and you can even manually trigger them by passing parameters externally if needed. (Workflow syntax for GitHub Actions https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#run-name)
(manually trigger workflow by passing parameters externally https://github.blog/changelog/2020-07-06-github-actions-manual-triggers-with-workflow_dispatch/ )
