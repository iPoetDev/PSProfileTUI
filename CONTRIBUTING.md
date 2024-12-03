# Contributing to PSProfileTUI

We love your input! We want to make contributing to PSProfileTUI as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

### 1. Fork and Clone
1. Fork the repo and create your branch from `main`
2. If you've added code that should be tested, add tests
3. Ensure the test suite passes
4. Make sure your code follows the project's style guidelines

### 2. Development Workflow

#### Code Changes
1. Make your changes in the appropriate module directory
2. Update the module's local `CHANGELOG.md` first
3. If applicable, update the module's documentation
4. Run tests to ensure no regressions

#### Documentation Updates
1. Update relevant README files in affected directories
2. For architectural decisions, update `PROJECTLOG.md`
3. For API changes, update relevant documentation files

### 3. Changelog Management

We follow a hierarchical changelog structure:

```
PSProfileTUI/
├── CHANGELOG.md              # Project-level changelog
├── PROJECTLOG.md            # Project development history
└── src/
    └── modules/
        └── ModuleName/
            └── CHANGELOG.md  # Module-specific changelog
```

#### Updating Changelogs

1. **Module Level**
   - First, update the module's `CHANGELOG.md`
   - Follow the [Keep a Changelog](https://keepachangelog.com/) format
   - Categorize changes as Added, Changed, Deprecated, Removed, Fixed, or Security
   - Include relevant issue/PR numbers

2. **Project Level**
   - After module changelog is updated, update root `CHANGELOG.md`
   - Summarize module changes at the project level
   - Maintain consistency with module changelogs

3. **Project History**
   - For architectural changes, update `PROJECTLOG.md`
   - Include rationale for significant changes
   - Document any migration steps if applicable

Example module changelog entry:
```markdown
### [Unreleased]
#### Added
- New feature X in module Y
- Enhancement to existing functionality

#### Changed
- Modified behavior of Z
```

Example project changelog entry:
```markdown
### [Unreleased]
#### ModuleY
- Added: New feature X
- Changed: Behavior of Z
```

### 4. Pull Request Process

1. Update Documentation
   - Update relevant module `CHANGELOG.md`
   - Update project `CHANGELOG.md`
   - Update `PROJECTLOG.md` if architectural changes are made
   - Update the README.md with details of changes to the interface

2. Review Process
   - Ensure all changelogs are updated
   - All tests pass
   - Code follows style guidelines
   - Documentation is updated

3. Merge Requirements
   - Changelog updates are complete
   - At least one maintainer approval
   - CI checks pass

## Style Guidelines

1. **PowerShell Code**
   - Follow [PowerShell Practice and Style](https://poshcode.gitbook.io/powershell-practice-and-style/)
   - Use consistent indentation (4 spaces)
   - Include comment-based help

2. **Commit Messages**
   - Use the imperative mood ("Add feature" not "Added feature")
   - Reference issues and pull requests
   - Keep first line under 72 characters

## Any contributions you make will be under the Project License

In short, when you submit code changes, your submissions are understood to be under the same [LICENSE](LICENSE) that covers the project. Feel free to contact the maintainers if that's a concern.

## Report bugs using GitHub's [issue tracker]

We use GitHub issues to track public bugs. Report a bug by [opening a new issue]().

## References

- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [PowerShell Practice and Style](https://poshcode.gitbook.io/powershell-practice-and-style/)
