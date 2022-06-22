view: habitat {
  sql_table_name: `io-sainsbury-common.lookertest.habitat`
  ;;

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }

  measure: total_clicks {
    type: sum
    sql: ${clicks} ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date
    ;;
  }

  dimension: financial_year {
    type: string
    sql: ${TABLE}.Financial_Year ;;
  }

  dimension: forecast_cost {
    type: number
    sql: ${TABLE}.forecast_cost ;;
  }

  measure: total_forecast_cost {
    type: sum
    sql: ${forecast_cost} ;;
  }

  dimension: forecast_orders {
    type: number
    sql: ${TABLE}.forecast_orders ;;
  }

  measure: total_forecast_orders {
    type: sum
    sql: ${forecast_orders} ;;
  }

  dimension: forecast_revenue {
    type: number
    sql: ${TABLE}.forecast_revenue ;;
  }

  measure: total_forecast_revenue {
    type: sum
    sql: ${forecast_revenue} ;;
  }

  dimension: forecast_sessions {
    type: number
    sql: ${TABLE}.forecast_sessions ;;
  }

  measure: total_forecast_sessions {
    type: sum
    sql: ${forecast_sessions} ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  measure: total_impressions {
    type: sum
    sql: ${impressions} ;;
  }

  dimension: orders {
    type: number
    sql: ${TABLE}.orders ;;
  }

  measure: total_orders {
    type: sum
    sql: ${orders} ;;
  }

  dimension: period {
    type: number
    sql: ${TABLE}.Period ;;
  }

  dimension: poe {
    type: string
    sql: ${TABLE}.POE ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${revenue} ;;
  }
  dimension: visits {
    type: number
    sql: ${TABLE}.visits ;;
  }

  measure: total_visits {
    type: sum
    sql: ${visits} ;;
  }
#### Updated by Anouar
  measure: visits_vs_forecast {
    type: number
    sql: (${total_visits}}-${total_forecast_sessions})/${total_forecast_sessions} ;;
  }

  measure: orders_vs_forecast {
    type: number
    sql: (${total_orders}-${total_forecast_orders})/${total_forecast_orders} ;;
  }
### End Update by Number : A measure should not reference another measure only if it's of. type number,
#percent_of_previous or
#percent_of_total or
#percentile or
#percentile_distinct or
#running_total or
  dimension: week_in_period {
    type: number
    sql: ${TABLE}.Week_in_Period ;;
  }

  dimension: week_in_year {
    type: number
    sql: ${TABLE}.Week_in_Year ;;
  }

  dimension: weekday {
    type: string
    sql: ${TABLE}.Weekday ;;
  }

  dimension: weekday_index {
    type: number
    sql: ${TABLE}.Weekday_Index ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
