package routes

import (
	"github.com/CarlosAsrc/url-shortener/api/handlers"
	appConfig "github.com/CarlosAsrc/url-shortener/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"

	"github.com/gorilla/mux"
)

func SetupRoutes(configs *appConfig.Config, db *dynamodb.Client) *mux.Router {
	router := mux.NewRouter()
	handler := &handlers.URLHandler{DynamoDBClient: db, TableName: configs.TableName}

	router.HandleFunc("/health", handlers.HealthHandler).Methods("GET")
	router.HandleFunc("/shorten", handler.ShortenURLHandler).Methods("POST")
	router.HandleFunc("/long-url/{shortURL}", handler.GetLongURLHandler).Methods("GET")

	return router
}
