# Contributing to FFmpeg Android Minimal Build

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

If you encounter a problem:

1. Check existing issues to avoid duplicates
2. Provide detailed information:
   - Build environment (OS, NDK version)
   - Error messages and logs
   - Steps to reproduce
   - Expected vs actual behavior

### Suggesting Enhancements

For feature requests:

1. Open an issue with the `enhancement` label
2. Describe the use case and benefits
3. Provide examples if applicable

### Code Contributions

#### Before You Start

- Check existing issues and PRs
- Discuss major changes in an issue first
- Ensure your contribution aligns with project goals

#### Development Workflow

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/ffmpeg-android-minimal.git
   cd ffmpeg-android-minimal
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Follow existing code style
   - Test your changes thoroughly
   - Update documentation as needed

4. **Test Locally**
   ```bash
   ./build_ffmpeg_android.sh
   ```

5. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add support for arm64-v8a architecture"
   ```

   Use conventional commit messages:
   - `feat:` New features
   - `fix:` Bug fixes
   - `docs:` Documentation updates
   - `refactor:` Code refactoring
   - `test:` Testing improvements
   - `chore:` Maintenance tasks

6. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a pull request on GitHub.

#### Pull Request Guidelines

- Clear title and description
- Reference related issues
- Include test results if applicable
- Update README or docs if needed
- One feature/fix per PR

### Code Style

#### Shell Scripts

- Use 4 spaces for indentation
- Add comments for complex logic
- Use meaningful variable names
- Quote variables: `"$VAR"` not `$VAR`
- Check scripts with shellcheck

#### YAML (GitHub Actions)

- Use 2 spaces for indentation
- Add comments for complex workflows
- Keep steps focused and named clearly

### Testing

Before submitting:

1. **Build test**
   ```bash
   ./build_ffmpeg_android.sh
   ```

2. **Verify output**
   ```bash
   ls -lh output/lib/
   file output/lib/libavcodec.a
   ```

3. **Check for errors**
   Review build logs for warnings or errors

### Documentation

When adding features:

- Update README.md
- Add comments to complex code
- Update build instructions if needed
- Include usage examples

## Areas for Contribution

### High Priority

- [ ] Support for additional architectures (arm64-v8a, x86, x86_64)
- [ ] Optimization flags tuning
- [ ] Dependency version updates
- [ ] Build time improvements
- [ ] Better error handling

### Medium Priority

- [ ] CMake integration examples
- [ ] Sample Android app
- [ ] Automated testing
- [ ] Docker build environment
- [ ] Build size analysis

### Documentation

- [ ] Integration tutorials
- [ ] Troubleshooting guides
- [ ] Performance benchmarks
- [ ] API usage examples

## Getting Help

- **Questions**: Open a discussion or issue
- **Bugs**: Open an issue with details
- **Security**: Report privately to maintainers

## Recognition

Contributors will be acknowledged in:
- Release notes
- CONTRIBUTORS.md file
- Project documentation

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the issue, not the person
- Help create a welcoming environment

## License

By contributing, you agree that your contributions will be licensed under the MIT License (for build scripts) and subject to the licenses of FFmpeg and its dependencies.

---

Thank you for contributing! 🎉
