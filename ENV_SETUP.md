# Environment Configuration Guide

## API URLs Configuration

The app uses environment variables to configure API endpoints. Edit the `.env` file in the root of `poultry_core` to change API URLs.

### Current Configuration

The `.env` file contains:
```
AUTH_API_BASE_URL=https://localhost:7010
FARM_API_BASE_URL=https://localhost:7190
NODE_ENV=development
```

### For Development

**If testing on Android Emulator:**
- Use `https://10.0.2.2:7010` for auth API
- Use `https://10.0.2.2:7190` for farm API

**If testing on iOS Simulator:**
- Use `https://localhost:7010` for auth API
- Use `https://localhost:7190` for farm API

**If testing on a real device:**
- Replace `localhost` with your development machine's IP address
- Example: `https://192.168.1.100:7010`

### For Production

Update the `.env` file with production URLs:
```
AUTH_API_BASE_URL=https://usermanagementapi.poultrycore.com
FARM_API_BASE_URL=https://farmapi.poultrycore.com
NODE_ENV=production
```

### Important Notes

1. Make sure your backend APIs are running before testing
2. For HTTPS with self-signed certificates in development, you may need to configure certificate pinning or allow insecure connections
3. The app will use default values (localhost) if the `.env` file is missing
4. Timeout is set to 60 seconds - adjust if needed in the provider files

