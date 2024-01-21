-include .env
export

app.build:
	docker-compose up --build

app.start:
	docker-compose up

app.stop:
	docker-compose down

console:
	docker exec -it $(APP_NAME) rails console

test:
	docker exec -e "RAILS_ENV=test" $(APP_NAME) bundle exec rspec spec/

db.setup:
	docker exec -it $(APP_NAME) rails db:create && docker exec -it $(APP_NAME) rails db:migrate

db.cli:
	docker exec -it $(POSTGRES_NAME) psql -U $(POSTGRES_USER)
