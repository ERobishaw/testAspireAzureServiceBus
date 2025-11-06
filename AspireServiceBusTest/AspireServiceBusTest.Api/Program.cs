using Azure.Messaging.ServiceBus;

var builder = WebApplication.CreateBuilder(args);

// Add service defaults
builder.AddServiceDefaults();

// Add Azure Service Bus client
builder.AddAzureServiceBusClient("sbcoremvp-local");

var app = builder.Build();

// Test endpoint to send a message to the queue
app.MapPost("/test-queue", async (ServiceBusClient serviceBusClient, ILogger<Program> logger) =>
{
    try
    {
        var sender = serviceBusClient.CreateSender("sb-q-well-tracker");
        
        var message = new ServiceBusMessage($"Test message sent at {DateTime.UtcNow:O}");
        
        await sender.SendMessageAsync(message);
        
        logger.LogInformation("Successfully sent message to queue 'sb-q-well-tracker' at {Time}", DateTime.UtcNow);
        
        return Results.Ok(new 
        { 
            status = "success", 
            message = "Message sent to queue 'sb-q-well-tracker'",
            timestamp = DateTime.UtcNow
        });
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Failed to send message to queue");
        return Results.Problem(
            detail: ex.Message,
            title: "Failed to send message to queue"
        );
    }
});

app.MapGet("/", () => "Azure Service Bus Test API - Use POST /test-queue to send a test message");

app.Run();
