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
	router.HandleFunc("/shorten", handler.ShortenURLHandler).Methods("POST")
	return router
}
