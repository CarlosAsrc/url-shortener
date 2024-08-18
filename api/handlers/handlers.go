package handlers

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"time"

	"github.com/CarlosAsrc/url-shortener/internal/shortening"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

type ShortenURLRequest struct {
	Long_URL string `json:"long_url"`
}

type ShortenURLResponse struct {
	Short_URL string `json:"short_url"`
}

type URLHandler struct {
	DynamoDBClient *dynamodb.Client
	TableName      string
}

func (h *URLHandler) ShortenURLHandler(w http.ResponseWriter, r *http.Request) {
	body, _ := io.ReadAll(r.Body)
	var request ShortenURLRequest
	json.Unmarshal(body, &request)

	longUrl := request.Long_URL

	shortURL := shortening.ShortenURL(longUrl)
	save(h, shortURL, longUrl)

	shortUrlResponse := ShortenURLResponse{Short_URL: shortURL}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(shortUrlResponse)
}

func save(h *URLHandler, shortURL string, longURL string) {

	item := map[string]types.AttributeValue{
		"shortUrl":    &types.AttributeValueMemberS{Value: shortURL},
		"longUrl":     &types.AttributeValueMemberS{Value: longURL},
		"createdAt":   &types.AttributeValueMemberS{Value: time.Now().Format(time.RFC3339Nano)},
		"accessCount": &types.AttributeValueMemberN{Value: "0"},
	}

	input := &dynamodb.PutItemInput{
		TableName: aws.String(h.TableName),
		Item:      item,
	}

	_, err := h.DynamoDBClient.PutItem(context.TODO(), input)
	if err != nil {
		log.Fatalf("Failed to put item, %v", err)
	}

	fmt.Println("Successfully added item to DynamoDB")
}
