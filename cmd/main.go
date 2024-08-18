package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/CarlosAsrc/url-shortener/api/routes"
	"github.com/CarlosAsrc/url-shortener/config"
	"github.com/CarlosAsrc/url-shortener/internal/db"
)

func main() {
	port := ":8080"

	config := config.GetConfig()

	dynamoDBClient := db.SetupDynamoDBClient(&config)
	router := routes.SetupRoutes(&config, dynamoDBClient)

	fmt.Printf("Server listening on port %s\n", port)
	server := &http.Server{
		Addr:    port,
		Handler: router,
	}

	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("Error starting server: %v\n", err)
	}
}
