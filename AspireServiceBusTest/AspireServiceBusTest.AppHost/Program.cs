var builder = DistributedApplication.CreateBuilder(args);

// Configure Azure Service Bus with emulator and custom queue
var serviceBus = builder.AddAzureServiceBus("sbcoremvp-local")
    .RunAsEmulator()
    .AddServiceBusQueue("sb-q-well-tracker");

// Add the API project and reference the Service Bus
var api = builder.AddProject<Projects.AspireServiceBusTest_Api>("api")
    .WithReference(serviceBus);

builder.Build().Run();
