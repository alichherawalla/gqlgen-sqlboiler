This program generates code like this between your generated gqlgen and sqlboiler with support for Relay.dev (unique id's etc). This in work in progress and we are working on automatically generating the basis Mutations like create, update, delete working based on your graphql scheme and your database models.

To make this program a success very tight coupling between your database and graphql scheme is needed at the moment. The advantage of this program is the most when you have a database already designed.

## Flow
1. Generate database structs with: https://github.com/volatiletech/sqlboiler  
    e.g. `sqlboiler mysql`
2. Generate GrapQL scheme from sqlboiler structs: https://github.com/web-ridge/sqlboiler-graphql-schema  
    e.g. `go run github.com/web-ridge/sqlboiler-graphql-schema --output=../schema.graphql`
3. Generate GrapQL structs with: https://github.com/99designs/gqlgen  
    e.g. `go run github.com/99designs/gqlgen`
4. Generate converts between gqlgen-sqlboiler with this program  
    e.g. `go run convert_plugin.go`

DONE: Generate converts between sqlboiler structs and graphql (with relations included)   
DONE: Generate converts between input models and sqlboiler   
DONE: Fetch sqlboiler preloads from graphql context    
TODO: Generate CRUD resolvers based on mutations in graphql scheme   
TODO: Refactor some code and document it   

## Case

You have a personal project with a very big database and a 'Laravel API'. I want to be able to generate a new Golang GraphQL API for this project in no time.

## Example result of this plugin

```golang
func UserToGraphQL(m *models.User) *graphql_models.User {
	if m == nil {
		return nil
	}
	r := &graphql_models.User{
		ID:                             UintToStringUniqueID(m.ID, "User"),
		Name:                           m.Name,
		LastName:                       m.LastName,
		Email:                          m.Email,
		Password:                       m.Password,
		RememberToken:                  NullDotStringToPointerString(m.RememberToken),
		CreatedAt:                      NullDotTimeToPointerInt(m.CreatedAt),
		UpdatedAt:                      NullDotTimeToPointerInt(m.UpdatedAt),
		DeletedAt:                      NullDotTimeToPointerInt(m.DeletedAt),
		SendNotificationsOnNewCalamity: BoolToInt(m.SendNotificationsOnNewCalamity),
	}
	if !UintIsZero(m.RoleID) {
		if m.R == nil || m.R.Role == nil {
			r.Role = RoleWithUintID(m.RoleID)
		} else {
			r.Role = RoleToGraphQL(m.R.Role)
		}
	}

	return r
}
```

sqlboiler.yml

```yaml
mysql:
  dbname: dbname
  host: localhost
  port: 8889
  user: root
  pass: root
  sslmode: "false"
  blacklist:
    - notifications
    - jobs
    - password_resets
    - migrations
mysqldump:
  column-statistics: 0
```

gqlgen.yml

```yaml
schema:
  - schema.graphql
exec:
  filename: graphql_models/generated.go
  package: graphql_models
model:
  filename: graphql_models/genereated_models.go
  package: graphql_models
resolver:
  filename: resolver.go
  type: Resolver
```

Run normal generator
`go run github.com/99designs/gqlgen -v`

Put this in your program convert_plugin.go e.g.

```golang
// +build ignore

// +build ignore

package main

import (
	"fmt"
	"os"

	"github.com/99designs/gqlgen/api"
	"github.com/99designs/gqlgen/codegen/config"
	cm "github.com/web-ridge/gqlgen-sqlboiler/modelgen"
)

func main() {
	cfg, err := config.LoadConfigFromDefaultLocations()
	if err != nil {
		fmt.Fprintln(os.Stderr, "failed to load config", err.Error())
		os.Exit(2)
	}

	err = api.Generate(cfg,
		api.AddPlugin(cm.New(
			"convert/convert.go",
			"models",
			"graphql_models",
		)), // This generates conversions structs
	)
	if err != nil {
		fmt.Println("error!!")
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(3)
	}
}


```

`go run convert_plugin.go`
