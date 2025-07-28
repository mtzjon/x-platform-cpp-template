# Dev Container Troubleshooting

## Permission Issues

If you're experiencing permission issues in the dev container, try these solutions:

### 1. Rebuild the Container

The most reliable fix is to rebuild the container:

```bash
# In VS Code Command Palette (Ctrl+Shift+P)
Remote-Containers: Rebuild Container
```

### 2. Manual Permission Fix

If rebuilding doesn't work, run this command in the container terminal:

```bash
# Fix workspace permissions
sudo chown -R developer:developer /home/developer/workspace
sudo chmod -R 755 /home/developer/workspace

# Fix home directory permissions
sudo chown -R developer:developer /home/developer

# Run the setup script
bash .devcontainer/setup.sh
```

### 3. Check User Identity

Verify you're running as the correct user:

```bash
whoami          # Should show 'developer'
id              # Should show uid=1000(developer) gid=1000(developer)
groups          # Should include 'sudo'
```

### 4. Test Sudo Access

Make sure you have sudo access:

```bash
sudo echo "Test"  # Should work without asking for password
```

### 5. Common Commands

If you still have issues, try these commands:

```bash
# Fix Conan permissions
sudo chown -R developer:developer /home/developer/.conan2

# Fix build directory permissions
sudo chown -R developer:developer /home/developer/workspace/build

# Re-run Conan setup
conan profile detect --force

# Test basic operations
touch test_file    # Should work
mkdir test_dir     # Should work
rm test_file test_dir  # Should work
```

### 6. Nuclear Option: Complete Reset

If nothing else works:

1. **Close VS Code**
2. **Remove containers and volumes**:
   ```bash
   docker system prune -a
   docker volume prune
   ```
3. **Reopen project in VS Code**
4. **Select "Reopen in Container"**

## Getting Help

If you're still having issues:

1. Check the container logs in VS Code
2. Open an issue with:
   - Your operating system
   - Docker version (`docker --version`)
   - VS Code version
   - Error messages from the container

## Prevention

To avoid permission issues:

- Don't modify files outside the container that are mounted inside
- Use the provided VS Code tasks instead of manual commands when possible
- Let the container handle all development operations