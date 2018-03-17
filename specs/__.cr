
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

  it "allows numbers in unquoted strings" do
    actual = DA_SQL.inline("a b {{1}}", %{cdf_123})
    assert actual == %{a b cdf_123}
  end # === it "allows numbers in strings"

  it "allows numbers in quoted strings" do
    actual = DA_SQL.inline("a b {{1}} {{2}}", %{"cdf_123"}, %{'efg-545'})
    assert actual == %{a b "cdf_123" 'efg-545'}
  end # === it "allows numbers in strings"

  it "allows Int32 values" do
    actual = DA_SQL.inline("a b {{1}} {{2}}", 1, 2)
    assert actual == %{a b 1 2}
  end # === it "allows Int32 values"

  it "allows Int64 values" do
    actual = DA_SQL.inline("a b {{1}} {{2}}", 1_i64, 2_i64)
    assert actual == %{a b 1 2}
  end # === it "allows Int64 values"

end # === desc "it works"
