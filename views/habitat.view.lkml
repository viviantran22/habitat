view: habitat {
  sql_table_name: `io-sainsbury-common.lookertest.habitat`
    ;;

  dimension: pk1 {
    type: string
    hidden: yes
    primary_key: yes
    sql: CONCAT(${date_date}, ${channel}) ;;
  }

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
    value_format_name: gbp
    drill_fields: [channel, total_cost]
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_month,
      week_of_year
    ]
    convert_tz: no
    datatype: timestamp
    sql: TIMESTAMP(${TABLE}.date)
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
    sql: (${total_visits}}-${total_forecast_sessions})/nullif(${total_forecast_sessions},0) ;;
  }

  measure: orders_vs_forecast {
    type: number
    sql: (${total_orders}-${total_forecast_orders})/nullif(${total_forecast_orders},0) ;;
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

  ### Example of Visits that detects if the filters is being used
  ### This could ensure you have one definition of total visits

  measure: total_visits_hybrid {
    description: "Use this if you want to keep one single definition of Visits across the explore"
    type: sum
    sql: {% if habitat.date_comparison_filter._in_query %}
          CASE WHEN ${this_week_vs_last_week} like 'This Week' THEN ${visits}
          ELSE NULL
          END
        {% else %}
          ${visits}
        {% endif %};;
  }

  ##### Week-over-Week (Full Week or Specific Days) Comparaison

  filter: date_comparison_filter {
    view_label: "Date Comparison"
    type: date
    sql: ${this_week_vs_last_week} is not null ;;
  }

  dimension: this_week_vs_last_week {
    hidden: no
    view_label: "Date Comparison"
    type: string
    sql: CASE
      WHEN {% condition date_comparison_filter %} ${date_raw} {% endcondition %} THEN 'This Week'
      WHEN ${date_raw} >= TIMESTAMP(DATE_ADD(CAST({% date_start date_comparison_filter %} AS DATE), INTERVAL -1 WEEK)) AND ${date_raw} < TIMESTAMP(DATE_ADD(CAST({% date_end date_comparison_filter %} AS DATE), INTERVAL -1 WEEK)) THEN 'Prior Week'
    END;;
  }

  dimension: this_year_last_year {
    hidden: yes
    view_label: "Date Comparison"
    type: string
    sql: CASE
      WHEN {% condition date_comparison_filter %} ${date_raw} {% endcondition %} THEN 'This Year'
      WHEN ${date_raw} >= TIMESTAMP(DATE_ADD(CAST({% date_start date_comparison_filter %} AS DATE), INTERVAL -1 YEAR)) AND ${date_raw} < TIMESTAMP(DATE_ADD(CAST({% date_end date_comparison_filter %} AS DATE), INTERVAL -1 YEAR)) THEN 'Prior Last Year'
    END;;
  }




  #### Start of Do7D and WoW Comparaison
  measure: visits_this_week {
    view_label: "Date Comparison"
    label: "Visits Current Week"
    description: "Te be used this with Date Comparaison Filter"
    type: sum
    sql: ${visits} ;;
    value_format: "#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }

  measure: visits_last_week {
    type: sum
    sql: ${visits} ;;
    value_format: "#,##0"
    filters: [this_week_vs_last_week: "Prior Week"]
    hidden: yes
  }

  measure: visits_percent_change {
    view_label: "Date Comparison"
    label: "Visits Change %"
    type: number
    sql: ${visits_this_week}/nullif(${visits_last_week},0) - 1 ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: visits_delta_change {
    view_label: "Date Comparison"
    label: "Visits Delta Δ"
    type: number
    sql: ${visits_this_week} - ${visits_last_week} ;;
    value_format: "#,##0"
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: forecasted_visits_this_week {
    view_label: "Date Comparison"
    label: "Forecasted Visits Current Week"
    description: "Te be used this with Date Comparaison Filter"
    type: sum
    sql: ${forecast_sessions} ;;
    value_format: "#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }

  measure: visits_vs_forecast_percent_difference {
    view_label: "Date Comparison"
    label: "Visits vs Forecast %"
    type: number
    sql: (${visits_this_week}-${forecasted_visits_this_week})/nullif(${forecasted_visits_this_week},0) ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }



  measure: orders_this_week {
    view_label: "Date Comparison"
    label: "Orders Current Week"
    description: "Te be used this with Date Comparaison Filter"
    type: sum
    sql: ${orders} ;;
    value_format: "#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }

  measure: orders_last_week {
    type: sum
    sql: ${orders} ;;
    value_format: "#,##0"
    filters: [this_week_vs_last_week: "Prior Week"]
    hidden: yes
  }

  measure: orders_percent_change {
    view_label: "Date Comparison"
    label: "Orders Change %"
    type: number
    sql: ${orders_this_week}/nullif(${orders_last_week},0) - 1 ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: orders_delta_change {
    view_label: "Date Comparison"
    label: "Orders Delta Δ"
    type: number
    sql: ${orders_this_week} - ${orders_last_week} ;;
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }


  measure: forecasted_orders_this_week {
    view_label: "Date Comparison"
    label: "Forecasted Orders Current Week"
    description: "Te be used this with Date Comparaison Filter"
    type: sum
    sql: ${forecast_orders} ;;
    value_format: "#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }


  measure: orders_vs_forecast_percent_difference {
    view_label: "Date Comparison"
    label: "Orders vs Forecast %"
    type: number
    sql: (${orders_this_week}-${forecasted_orders_this_week})/nullif(${forecasted_orders_this_week},0) ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }


  measure: revenue_this_week {
    view_label: "Date Comparison"
    label: "Revenue Current Week"
    description: "Te be used this with Date Comparaison Filter"
    type: sum
    sql: ${revenue} ;;
    value_format: "\"£\"#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }

  measure: revenue_last_week {
    type: sum
    sql: ${revenue} ;;
    value_format: "\"£\"#,##0"
    filters: [this_week_vs_last_week: "Prior Week"]
    hidden: yes
  }

  measure: revenue_percent_change {
    view_label: "Date Comparison"
    label: "Revenue Change %"
    type: number
    sql: ${revenue_this_week}/nullif(${revenue_last_week},0) - 1 ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: revenue_delta_change {
    view_label: "Date Comparison"
    label: "Revenue Delta Δ"
    type: number
    sql: ${revenue_this_week} - ${revenue_last_week} ;;
    value_format: "\"£\"#,##0"
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: forecasted_revenue_this_week {
    view_label: "Date Comparison"
    label: "Forecasted Revenue Current Week"
    description: "Te be used this with Date Comparaison Filter"
    type: sum
    sql: ${forecast_revenue} ;;
    value_format: "\"£\"#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }


  measure: revenue_vs_forecast_percent_difference {
    view_label: "Date Comparison"
    label: "Revenue vs Forecast %"
    type: number
    sql: (${revenue_this_week}-${forecasted_revenue_this_week})/nullif(${forecasted_revenue_this_week},0) ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }


  measure: cost_this_week {
    view_label: "Date Comparison"
    label: "Cost Current Week"
    description: "Te be used this with Date Comparaison Filter"
    type: sum
    sql: ${cost} ;;
    value_format: "\"£\"#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }

  measure: cost_last_week {
    type: sum
    sql: ${cost} ;;
    value_format: "\"£\"#,##0"
    filters: [this_week_vs_last_week: "Prior Week"]
    hidden: yes
  }

  measure: cost_percent_change {
    view_label: "Date Comparison"
    label: "Cost Change %"
    type: number
    sql: ${cost_this_week}/nullif(${cost_last_week},0) - 1 ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: cost_delta_change {
    view_label: "Date Comparison"
    label: "Cost Delta Δ"
    type: number
    sql: ${cost_this_week} - ${cost_last_week} ;;
    value_format: "\"£\"#,##0"
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: forecasted_cost_this_week {
    view_label: "Date Comparison"
    label: "Forecasted Cost Current Week"
    description: "Te be used this with Date Comparaison Filter"
    type: sum
    sql: ${forecast_cost} ;;
    value_format: "\"£\"#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }

  measure: cost_vs_forecast_percent_difference {
    view_label: "Date Comparison"
    label: "Cost vs Forecast %"
    type: number
    sql: (${cost_this_week}-${forecasted_cost_this_week})/nullif(${forecasted_cost_this_week},0) ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

##### Year-over-Year (Full Week or Specific Days) Comparison

  filter: yearly_date_comparison_filter {
    view_label: "Yearly Date Comparison"
    type: date
    sql: ${this_year_vs_last_year} is not null ;;
  }

  dimension: this_year_vs_last_year {
    hidden: no
    view_label: "Yearly Date Comparison"
    type: string
    sql: CASE
      WHEN {% condition yearly_date_comparison_filter %} ${date_raw} {% endcondition %} THEN 'This Year'
      WHEN ${date_raw} >= TIMESTAMP(DATE_ADD(CAST({% date_start yearly_date_comparison_filter %} AS DATE), INTERVAL -52 WEEK)) AND ${date_raw} < TIMESTAMP(DATE_ADD(CAST({% date_end yearly_date_comparison_filter %} AS DATE), INTERVAL -52 WEEK)) THEN 'Last Year'
    END;;
  }

  #### Start of YoY Comparaison
  measure: visits_this_week_y {
    view_label: "Yearly Date Comparison"
    label: "Visits Current Week"
    description: "Te be used this with Yearly Date Comparison Filter"
    type: sum
    sql: ${visits} ;;
    value_format: "#,##0"
    filters: [this_year_vs_last_year: "This Week"]
    hidden: no
  }

  measure: visits_last_year {
    type: sum
    sql: ${visits} ;;
    value_format: "#,##0"
    filters: [this_year_vs_last_year: "Last Year"]
    hidden: yes
  }

  measure: visits_percent_change_this_year {
    view_label: "Yearly Date Comparison"
    label: "Visits Change %"
    type: number
    sql: ${visits_this_week}/nullif(${visits_last_year},0) - 1 ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: visits_delta_change_this_year {
    view_label: "Yearly Date Comparison"
    label: "Visits Delta Δ"
    type: number
    sql: ${visits_this_week} - ${visits_last_year} ;;
    value_format: "#,##0"
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }

  measure: forecasted_visits_this_week_this_year {
    view_label: "Yearly Date Comparison"
    label: "Forecasted Visits Current Week"
    description: "Te be used this with Yearly Date Comparison Filter"
    type: sum
    sql: ${forecast_sessions} ;;
    value_format: "#,##0"
    filters: [this_week_vs_last_week: "This Week"]
    hidden: no
  }

  measure: visits_vs_forecast_percent_difference_this_year {
    view_label: "Yearly Date Comparison"
    label: "Visits vs Forecast %"
    type: number
    sql: (${visits_this_week}-${forecasted_visits_this_week_this_year})/nullif(${forecasted_visits_this_week_this_year},0) ;;
    value_format_name: percent_2
    html: {% if value > 0 %} <font color="green"> {{linked_value}} ▲ </font>
          {% elsif value < 0 %} <font color="red"> {{linked_value}} ▼ </font>
          {% else %}
          <font color="black"> {{linked_value}} ▬ </font>
          {% endif %};;
    drill_fields: [clicks]
  }






}
