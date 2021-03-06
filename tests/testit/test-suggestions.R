library(testit)

# Test that out disposal of stringr
# was safe

if (requireNamespace("stringr", quietly = TRUE)) {
  a <- b <- paste0(letters, collapse = "")
  stringr_oui_1 <- stringr::str_sub(a, 2, 4)
  stringr_non_1 <- stringr__str_sub(a, 2, 4)
  assert("stringr str_sub same as before",
         identical(stringr_oui_1,
                   stringr_non_1))

  # Substitution was quite difficult to mimc

  test_stringr_sub_assign <- function(string, start, stop, value,
                                      verbose = getOption("_test_stringr_verbose_", FALSE)) {
    # avoid race condition: string will be modified in-place

    if (verbose) {
      stringA <- stringB <- string
      stringr::str_sub(stringA, start, stop) <- value
      stringB <- stringr__str_sub_assign(stringB, start, stop, value = value)
      cat("\n", stringA, "\n", stringB, "\n\n")
    }
    stringA <- stringB <- string
    assert(paste("Test conformance with stringr", string, start, stop, value),
           identical({
             stringr::str_sub(stringA, start, stop) <- value
             stringA
           },
           {
             stringr__str_sub_assign(stringB, start, stop, value = value)
           }))


  }


  test_stringr_sub_assign(a, 0, 0, "x")
  test_stringr_sub_assign(a, 3, 3, "x")
  test_stringr_sub_assign(a, 26, 26, "x")
  test_stringr_sub_assign(a, 3, 6, "x")
  test_stringr_sub_assign(a, 3, -3, "x")
  test_stringr_sub_assign(a, 3, 3, "XY")
  test_stringr_sub_assign(a, 3, 6, "XY")
  test_stringr_sub_assign(a, 3, -3, "XY")
  test_stringr_sub_assign(a, 3, 3, "0123")
  test_stringr_sub_assign(a, 3, 6, "0123")
  test_stringr_sub_assign(a, 3, -3, "0123")
  test_stringr_sub_assign(a, 0, 0, "0123")
  test_stringr_sub_assign(a, 0, 2, "0123")
  test_stringr_sub_assign(a, 0, -3, "0123")
  test_stringr_sub_assign(a, 0, 0, "x")
  test_stringr_sub_assign(a, 0, 2, "x")
  test_stringr_sub_assign(a, 0, -3, "x")

  test_stringr_sub_assign("# Regression on {{i}}\n```{r lm-{{i}}}\nlm(mpg~{{i}}, data=mtcars)",
                          17,
                          21,
                          value = "gear")

  test_stringr_sub_assign("()()()!", 5, 6, value = "!%")

  test_stringr_sub_assign("()()()!", 5, 6, value = "")
  test_stringr_sub_assign("()()()!", 7, 7, value = "")
  test_stringr_sub_assign("()()()!", 8, 8, value = "")


} else {
  assert("(stringr conformance not tested)", TRUE, TRUE)
}


if (requireNamespace("stringr", quietly = TRUE)) {
  string  = c("sdfoihsdfoi", "read_chunk('salve');(read_chunk('read_chunk')))", "read_chunk()")
  pattern = "read_chunk\\(([^)]+)\\)"
  assert("read chunks extracted without stringr",
         identical(stringr__str_extract_all(string = string, pattern = pattern, .use_stringr = FALSE),
                   stringr::str_extract_all(string = string, pattern = pattern)))

  string  = '# Regression on {{i}}NN```{r lm-{{i}}}NNlm(mpg~{{i}}, data=mtcars)NN```'
  pattern = '\\{\\{((.|NN)+?)\\}\\}'
  assert("read chunks extracted without stringr",
         identical(stringr__str_extract_all(string = string, pattern = pattern, .use_stringr = FALSE),
                   stringr::str_extract_all(string = string, pattern = pattern)))
}











