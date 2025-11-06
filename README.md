# .NET 9 Aspire 9.5.2 Azure Service Bus Test Project

This is a minimal .NET 9 test project using .NET Aspire 9.5.2 that demonstrates Azure Service Bus integration with a local emulator and custom queue.

## Project Structure

- **AspireServiceBusTest.AppHost** - The Aspire app host that orchestrates the application and configures the Azure Service Bus emulator
- **AspireServiceBusTest.Api** - A minimal API project that provides an endpoint to test sending messages to the Service Bus queue
- **AspireServiceBusTest.ServiceDefaults** - Shared service defaults for observability and resilience

## Features

- ✅ .NET 9 SDK
- ✅ .NET Aspire 9.5.2
- ✅ Azure Service Bus running as local emulator
- ✅ Custom queue named `sb-q-well-tracker`
- ✅ Minimal API endpoint for testing queue messages
- ✅ Logging and observability through Aspire Dashboard

## Prerequisites

- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) (required for running the Service Bus emulator)
- Aspire workload installed (see installation instructions below)

### Installing Aspire Workload

If you haven't installed the Aspire workload yet, run:

```bash
dotnet workload install aspire
```

## Running the Application

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd testAspireAzureServiceBus/AspireServiceBusTest
   ```

2. **Ensure Docker Desktop is running** (required for the Service Bus emulator)

3. **Run the Aspire AppHost**:
   ```bash
   cd AspireServiceBusTest.AppHost
   dotnet run
   ```

4. **Access the Aspire Dashboard**:
   - The Aspire Dashboard will automatically open in your browser
   - If it doesn't open automatically, look for the dashboard URL in the console output (typically http://localhost:15888)
   - The dashboard shows all running resources including the Service Bus emulator and the API

## Testing the Queue Endpoint

### Option 1: Using the Provided Test Scripts

#### Linux/macOS:
```bash
./test-queue.sh [port]
```

#### Windows (PowerShell):
```powershell
.\test-queue.ps1 -Port [port]
```

If you don't specify a port, the scripts will default to port 5000. Find the actual API port in the Aspire Dashboard.

### Option 2: Using curl

Send a test message to the queue:

```bash
curl -X POST http://localhost:<api-port>/test-queue
```

The API port is dynamically assigned. You can find it in:
- The Aspire Dashboard under the "api" resource
- The console output when running the AppHost

### Option 3: Using a REST Client

You can also use any HTTP client like:
- Postman
- Insomnia
- Thunder Client (VS Code extension)
- REST Client (VS Code extension)

### Expected Response

On success, you'll receive a JSON response like:

```json
{
  "status": "success",
  "message": "Message sent to queue 'sb-q-well-tracker'",
  "timestamp": "2024-01-01T12:00:00.0000000Z"
}
```

### Viewing Logs

The API logs each message send operation. You can view logs in:
1. The Aspire Dashboard - Navigate to the "api" resource and click on "Logs"
2. The console output where the AppHost is running

## Configuration Details

### Service Bus Configuration (AppHost)

The Service Bus is configured in `AspireServiceBusTest.AppHost/Program.cs`:

```csharp
var serviceBus = builder.AddAzureServiceBus("sbcoremvp-local")
    .RunAsEmulator()
    .AddServiceBusQueue("sb-q-well-tracker");
```

- **Resource Name**: `sbcoremvp-local`
- **Emulator Mode**: Enabled with `RunAsEmulator()`
- **Queue Name**: `sb-q-well-tracker`

### API Configuration

The API is configured to use the Service Bus client in `AspireServiceBusTest.Api/Program.cs`:

```csharp
builder.AddAzureServiceBusClient("sbcoremvp-local");
```

This automatically connects to the Service Bus emulator configured in the AppHost.

## Project Files

### Key Files

- `AspireServiceBusTest.AppHost/Program.cs` - Configures the Service Bus emulator and queue
- `AspireServiceBusTest.Api/Program.cs` - Implements the `/test-queue` endpoint
- `AspireServiceBusTest.AppHost/AspireServiceBusTest.AppHost.csproj` - AppHost project with Aspire 9.5.2 packages
- `AspireServiceBusTest.Api/AspireServiceBusTest.Api.csproj` - API project with Service Bus client package

## Troubleshooting

### Docker Not Running

If you see errors about Docker, ensure Docker Desktop is running before starting the application.

### Port Conflicts

If you encounter port conflicts, you can modify the ports in the `launchSettings.json` files or let Aspire assign random ports.

### Service Bus Connection Issues

- Verify the Service Bus emulator is running (check the Aspire Dashboard)
- Check the console logs for any error messages
- Ensure the queue name matches in both AppHost and API code

## Clean Up

To stop the application:
1. Press `Ctrl+C` in the terminal where the AppHost is running
2. Docker containers will be automatically cleaned up by Aspire

## Additional Resources

- [.NET Aspire Documentation](https://learn.microsoft.com/dotnet/aspire/)
- [Azure Service Bus Documentation](https://learn.microsoft.com/azure/service-bus-messaging/)
- [.NET 9 Documentation](https://learn.microsoft.com/dotnet/core/whats-new/dotnet-9)

## License

This is a test project for demonstration purposes.
