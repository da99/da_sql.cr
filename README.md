

# da\_sql.cr

A small tool I use to lower the chance of
a SQL injection attack.

# Intro.

```crystal
  require "da_sql"


  DA_SQL.exec(
    the_connection,
    the_sql,
    { DA_SQL::Inline_Value, DA_SQL::Inline_Value },
    { DA_SQL::Clean_Value, DA_SQL::Clean_Value }
  )

```
