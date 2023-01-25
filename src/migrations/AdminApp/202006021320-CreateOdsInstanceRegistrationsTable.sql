CREATE TABLE adminapp.OdsInstanceRegistrations (
    Id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    Name VARCHAR(256) NOT NULL,
	Description VARCHAR NULL,
    CONSTRAINT PK_OdsInstanceRegistrations PRIMARY KEY (Id)
)
