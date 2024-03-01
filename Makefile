-include .env
export

app.build:
	docker-compose up --build

app.start:
	docker-compose up

app.stop:
	docker-compose down

console:
	docker exec -it $(APP_CNAME) rails console

test:
	docker exec -e "RAILS_ENV=test" $(APP_CNAME) bundle exec rspec $(path)

db.setup:
	docker exec -it $(APP_CNAME) rails db:create && docker exec -it $(APP_CNAME) rails db:migrate

db.cli:
	docker exec -it $(POSTGRES_CNAME) psql -U $(POSTGRES_USER)
