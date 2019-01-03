After { |scenario|
  if scenario.failed?
    $browser.close
  end
}