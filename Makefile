.PHONY: http_tests
http_tests:
	docker run -v ./http_tests:/app -w /app -it ghcr.io/orange-opensource/hurl:latest --verbose --test documents.hurl