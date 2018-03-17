
require "da_spec"
require "../src/da_sql"

extend DA_SPEC

describe ".inline" do

  it "returns a SQL string with inlined values" do
    sql = <<-EOF
      SELECT {{2}} from {{1}};
    EOF

    pair = DA_SQL.inline(
      sql,
      "the_table",
      "NOW"
    )
    assert pair.strip == "SELECT NOW from the_table;"
  end # === it "works"

  it "raises an index out of bounds error if not enough inline values" do
    sql = <<-EOF
      SELECT {{2}} from {{1}};
    EOF

    assert_raises(IndexError) {
      DA_SQL.inline( sql, DA_SQL.inline("the_table") )
    }
  end # === it "raises an index out of bounds error if not enough inline values"

  it "raises DA_SQL::Error if value is not a String | Int32 | Int64" do
    assert_raises(DA_SQL::Error) {
      DA_SQL.inline(" SELECT {{1}} ", Time.now)
    }
  end # === it "raises DA_SQL::Error if value is not a String | Int32 | Int64"

  it "raises DA_SQL::Error if quoted string has quotes inside it " do
    assert_raises(DA_SQL::Error) {
      DA_SQL.inline(" SELECT {{1}} ", %{'a"b'})
    }
  end

  it "allows single quotes at the beginning and end points" do
    actual = DA_SQL.inline("a b {{1}}", "'c'")
    assert actual == "a b 'c'"
  end # === it "allows single quotes at the beginning and end points"

  it "allows double quotes at the beginning and end points" do
    actual = DA_SQL.inline("a b {{1}}", %{"c"})
    assert actual == %{a b "c"}
  end # === it "allows single quotes at the beginning and end points"

end # === desc "it works"
