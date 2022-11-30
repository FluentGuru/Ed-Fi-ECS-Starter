CREATE TABLE adminapp.ApplicationConfigurations (
    Id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    AllowUserRegistration BOOLEAN NOT NULL,
    CONSTRAINT PK_ApplicationConfigurations PRIMARY KEY (Id)
)
