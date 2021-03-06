context("unneeded_concatenation_linter")

test_that("returns the correct linting", {
  linter <- unneeded_concatenation_linter
  msg_c <- rex::escape("Unneded concatenation of a constant. Remove the \"c\" call.")
  msg_e <- rex::escape(
    "Unneded concatenation without arguments. Replace the \"c\" call by NULL or vector().")

  expect_lint("c(x)", NULL, linter)
  expect_lint("c(1, 2)", NULL, linter)
  expect_lint("c(x, recursive=TRUE)", NULL, linter)
  expect_lint("c(1, recursive=FALSE)", NULL, linter)
  expect_lint("lapply(1, c)", NULL, linter)

  expect_lint("c()", c(message=msg_e, line_number=1L, column_number=1L), linter)
  expect_lint("c(NULL)", c(message=msg_c, line_number=1L, column_number=1L), linter)
  expect_lint("c(1)", c(message=msg_c, line_number=1L, column_number=1L), linter)
  expect_lint("c (\n'a' )", c(message=msg_c, line_number=1L, column_number=1L), linter)
  expect_lint("c(y, c('c('),\nc())",
              list(
                c(message=msg_c, line_number=1L, column_number=6L),
                c(message=msg_e, line_number=2L, column_number=1L)
              ),
              linter)
})

