up:
	docker-compose up --build api

exec:
	docker-compose exec api bundle exec $(filter-out $@,$(MAKECMDGOALS))

console:
	docker-compose exec api bundle exec rails console

lint:
	docker-compose exec api rubocop
	docker-compose exec api rubycritic
	docker-compose exec api brakeman

test:
	docker-compose exec api bundle exec rspec $(filter-out $@,$(MAKECMDGOALS))
