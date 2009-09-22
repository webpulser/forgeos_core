# Date and Time formats
Time::DATE_FORMATS[:slashed_fr] = "%d/%m/%Y"
Date::DATE_FORMATS[:slashed_fr] = "%d/%m/%Y"

Date::DATE_FORMATS[:long_ordinal] = lambda { |date| date.strftime("%B #{date.day.ordinalize}") }
Date::DATE_FORMATS[:long_ordinal_with_day] = lambda { |date| date.strftime("%A, %B #{date.day.ordinalize}") }

