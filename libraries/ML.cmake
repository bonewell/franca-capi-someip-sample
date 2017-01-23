project(ML)

set(INTERFACES
  ford.rnd.ML:1
  ford.rnd.SmartML:1
)

create_someip_library(${PROJECT_NAME} "${INTERFACES}")

