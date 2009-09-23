{
  :fr => {
    :time => {
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| "%d/%m/%Y %H:%M:%S #{time.formatted_offset(false, 'UTC')}" }
        }
      }
    }
  }
}
