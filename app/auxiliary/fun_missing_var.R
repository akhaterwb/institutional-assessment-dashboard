missing_var <- function(data, base_country, country_list, comparison_countries, vars, variable_names) {

  # List all relevant countries
  comparison_list <-
    country_list %>%
    filter(country_name %in% comparison_countries)

  # List all variables that are missing for the base country -- these will be removed from the data
  na_indicators <-
    data %>%
    ungroup() %>%
    filter(country_name %in% base_country) %>%
    select(-(1:5)) %>%
    summarise(across(everything(), ~ if_else(any(is.na(.)), NA, sum(., na.rm = TRUE)))) %>%
    select(where(is.na)) %>%
    distinct() %>%
    names 

  # List final relevant variables: those selected, minus those missing
  variables <-
    setdiff(vars, na_indicators)

  variables <-
    intersect(variables, names(data))

  # List specific family variables missing
  missing_variables <-
    vars[vars %in% na_indicators] %>%
    data.frame() %>%
    rename("variable"=".") %>%
    left_join(variable_names %>% select(variable,var_name), by = "variable") %>%
    .$var_name

}


missing_var_dyn <- function(data, base_country, country_list, comparison_countries, vars, variable_names) {
  
  # List all relevant countries
  comparison_list <-
    country_list %>%
    filter(country_name %in% comparison_countries)
  
  # List all variables that are missing for the base country -- these will be removed from the data
  # na_indicators <-
  #   data %>%
  #   ungroup() %>%
  #   filter(country_name == base_country) %>%
  #   select(where(is.na)) %>%
  #   names
  
  na_indicators_df <-
    data %>%
    ungroup() %>%
    filter(country_name == base_country) 
  
  missing_vars <- sapply(na_indicators_df, function(x) sum(is.na(x)) / length(x))
  na_indicators <- names(missing_vars[missing_vars == 1])
  
  # List final relevant variables: those selected, minus those missing
  # variables <-
  #   setdiff(vars, na_indicators)
  # 
  # variables <-
  #   intersect(variables, names(data))
  
  if(length(na_indicators) != 0){
    variables <-
      setdiff(vars, na_indicators)
    variables <-
      intersect(variables, names(data))
  }else{
    variables <- vars
  }
  
  # List specific family variables missing
  missing_variables <-
    vars[vars %in% na_indicators] %>%
    data.frame() %>%
    rename("variable"=".") %>%
    left_join(variable_names %>% select(variable,var_name), by = "variable") %>%
    .$var_name
  
  missing_variables <- unique(missing_variables)
  
}

