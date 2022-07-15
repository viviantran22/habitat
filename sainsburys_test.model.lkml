connection: "habitat"

week_start_day: sunday

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

datagroup: cache_policy_report {
  max_cache_age: "24 hours"
  sql_trigger: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*8)/(60*60*24)) ;;
}



explore: habitat {

  persist_with: cache_policy_report

}
