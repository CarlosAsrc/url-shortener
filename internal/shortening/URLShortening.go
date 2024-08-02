package shortening

import (
	"hash/crc32"

	"github.com/catinello/base62"
)

func ShortenURL(longUrl string) string {
	hasher := crc32.NewIEEE()
	hasher.Write([]byte(longUrl))
	return base62.Encode(int(hasher.Sum32()))
}
