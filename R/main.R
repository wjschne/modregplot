#' @title modregplot
#' @description generates simple slopes plot from moderated regression equation
#' @param predictor_range a length 2 vector of the range of values to be plotted on the predictor variable, Default: c(-4, 4)
#' @param moderator_values a vector of moderator values to be plotted, Default: c(-1, 0, 1)
#' @param intercept the intercept of the regression equation, Default: 0
#' @param predictor_coef the regression coefficient for the predictor variable, Default: 0
#' @param moderator_coef the regression coefficient for the moderator variable, Default: 0
#' @param interaction_coef the interaction term coefficent, Default: 0
#' @param predictor_label the label for the predictor variable, Default: 'X'
#' @param criterion_label the label for the moderator variable, Default: 'Y'
#' @param moderator_label PARAM_DESCRIPTION, Default: 'Moderator'
#' @return a ggplot of the simple slopes
#' @examples
#' modregplot(
#'   predictor_range = c(-2, 2),
#'   moderator_values = c(Low = -1, High = 1),
#'   intercept = 6,
#'   predictor_coef = 2,
#'   moderator_coef = 0,
#'   interaction_coef = 1,
#'   predictor_label = "Psychopathy",
#'   criterion_label = "Aggression",
#'   moderator_label = "Impulsivity"
#' )
#' @rdname modregplot
#' @export
modregplot <- function(predictor_range = c(-4,4),
                            moderator_values = c(-1,0,1),
                            intercept = 0,
                            predictor_coef = 0,
                            moderator_coef = 0,
                            interaction_coef = 0,
                            predictor_label = "X",
                            criterion_label = "Y",
                            moderator_label = "Moderator") {
  d <- tidyr::crossing(x = predictor_range,
                       m = moderator_values)
  d <- dplyr::mutate(
    d,
    xm = .data$x * .data$m,
    yhat = intercept +
      .data$x * predictor_coef +
      .data$m * moderator_coef +
      .data$xm * interaction_coef
  )

  if (is.null(names(moderator_values))) {
    d <- dplyr::mutate(
      d,
      m = factor(.data$m)
    )
  } else {
    d <- dplyr::mutate(
      d,
      m = factor(.data$m,
                 levels = moderator_values,
                 labels = names(moderator_values))
    )
  }


  ggplot2::ggplot(d, ggplot2::aes(.data$x, .data$yhat, color = .data$m)) +
    ggplot2::geom_line() +
    ggplot2::labs(x = predictor_label,
                  y = criterion_label,
                  color = moderator_label)

}
