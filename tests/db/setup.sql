DROP TABLE IF EXISTS Person;

CREATE TABLE IF NOT EXISTS Person (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL
);

INSERT INTO Person (name, age) VALUES ('John', 30);
INSERT INTO Person (name, age) VALUES ('Jane', 25);
INSERT INTO Person (name, age) VALUES ('Fred', 20);
INSERT INTO Person (name, age) VALUES ('Sally', 35);
INSERT INTO Person (name, age) VALUES ('Richard', 40);
INSERT INTO Person (name, age) VALUES ('Mary', 45);

SELECT * FROM Person;
