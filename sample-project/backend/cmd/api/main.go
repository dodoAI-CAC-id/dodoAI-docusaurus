package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"sample-project/internal/database"
	"sample-project/internal/handlers"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables from .env file
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using environment variables")
	}

	// Initialize database connection
	db, err := database.InitDB()
	if err != nil {
		log.Fatalf("Failed to initialize database: %v", err)
	}
	defer db.Close()

	// Set Gin mode
	ginMode := os.Getenv("GIN_MODE")
	if ginMode == "" {
		ginMode = "debug"
	}
	gin.SetMode(ginMode)

	// Initialize Gin router
	router := gin.Default()

	// CORS middleware
	router.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	})

	// Initialize handlers
	incidentHandler := handlers.NewIncidentHandler(db)
	notificationHandler := handlers.NewNotificationHandler(db)
	actionHandler := handlers.NewActionHandler(db)
	personHandler := handlers.NewPersonHandler(db)
	staffHandler := handlers.NewStaffHandler(db)
	roomHandler := handlers.NewRoomHandler(db)
	videoHandler := handlers.NewIncidentVideoHandler(db)
	auditLogHandler := handlers.NewAuditLogHandler(db)
	configHandler := handlers.NewConfigurationHandler(db)

	// Setup routes - V2 (Microservice API)
	v2 := router.Group("/api/v2")
	{
		// Incidents
		v2.GET("/incidents", incidentHandler.GetIncidents)
		v2.POST("/incidents", incidentHandler.CreateIncident)
		v2.GET("/incidents/:id", incidentHandler.GetIncident)
		v2.PATCH("/incidents/:id", incidentHandler.UpdateIncident)

		// Incident Actions (must use :id to match parent route)
		v2.GET("/incidents/:id/actions", actionHandler.GetActionsByIncident)
		v2.POST("/incidents/:id/actions", actionHandler.CreateAction)

		// Incident Videos (must use :id to match parent route)
		v2.GET("/incidents/:id/videos", videoHandler.GetIncidentVideos)
		v2.GET("/videos/:id/file", videoHandler.GetVideoFile)

		// Notifications
		v2.GET("/notifications", notificationHandler.GetNotifications)
		v2.POST("/notifications", notificationHandler.CreateNotification)
		v2.POST("/notifications/:id/mark-read", notificationHandler.MarkNotificationAsRead)
		v2.POST("/notifications/:id/escalate", notificationHandler.EscalateNotification)

		// Persons
		v2.GET("/persons", personHandler.GetPersons)
		v2.POST("/persons", personHandler.CreatePerson)
		v2.GET("/persons/:id", personHandler.GetPerson)
		v2.PATCH("/persons/:id", personHandler.UpdatePerson)
		v2.DELETE("/persons/:id", personHandler.DeletePerson)

		// Staffs
		v2.GET("/staffs", staffHandler.GetStaffs)
		v2.GET("/staffs/:id", staffHandler.GetStaff)
		v2.GET("/departments", staffHandler.GetDepartments)

		// Rooms
		v2.GET("/rooms", roomHandler.GetRooms)
		v2.GET("/rooms/:id", roomHandler.GetRoom)

		// Camera Devices
		v2.GET("/camera-devices", roomHandler.GetCameraDevices)
		v2.GET("/camera-devices/:id", roomHandler.GetCameraDevice)

		// Detection Areas
		v2.GET("/detection-areas", roomHandler.GetDetectionAreas)

		// Audit Logs
		v2.GET("/audit-logs", auditLogHandler.GetAuditLogs)

		// Configuration
		v2.GET("/configurations", configHandler.GetConfiguration)
		v2.PATCH("/configurations", configHandler.UpdateConfiguration)
	}

	// Get API port from environment variable
	port := os.Getenv("API_PORT")
	if port == "" {
		port = "8080"
	}

	// Create HTTP server
	srv := &http.Server{
		Addr:    ":" + port,
		Handler: router,
	}

	// Start server in a goroutine
	go func() {
		log.Printf("Starting server on port %s", port)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("Failed to start server: %v", err)
		}
	}()

	// Graceful shutdown
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	log.Println("Shutting down server...")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalf("Server forced to shutdown: %v", err)
	}

	log.Println("Server exited")
}
