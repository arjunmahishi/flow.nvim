db:
	docker-compose down
	
	docker-compose up -d test_db
	docker-compose run --rm wait_postgres
	cat setup.sql | docker exec -i --user postgres `docker-compose ps -q test_db` psql flow_nvim_test_db
