# encoding: utf-8
module AmazonJobs

  class Home
    include PageObject

    div(:search_area, class: 'row nopadding location-search-bar')
    text_field(:search_type) { search_area_element.text_field_element(id: 'search_typeahead') }
    text_field(:search_location) { search_area_element.text_field_element(id: 'location-typeahead') }
    button(:search_button, id: 'search-button')

    def search(info)
      search_type_element.when_present.value     = info['tipo'] if info.has_key?('tipo')
      search_location_element.when_present.value = info['localizacao'] if info.has_key?('localizacao')
      search_button
    end
  end

  class Search
    include PageObject

    ###### search area definition ###### #search-container
    div(:search_area, id: 'search-container')
    divs(:clear_search_area) { search_area_element.div_elements(class: /.*clear-icon/) }
    text_field(:search_type) { search_area_element.text_field_element(id: 'search_typeahead') }
    paragraphs(:search_type_tip) { search_type_element.parent.paragraph_elements(class: 'keyword-texts') }
    text_field(:search_location) { search_area_element.text_field_element(id: 'location-typeahead') }
    button(:search_button) { search_area_element.button_element(css: '#search-container > div > form > button') }

    ###### jobs area definition ######
    div(:jobs_area, class: /search-page-job-list/)
    div(:no_jobs) { jobs_area_element.div_element(id: 'search-empty') }
    div(:jobs_list) { jobs_area_element.div_element(class: /job-tile-lists/) }

    ###### filters area definition ######
    div(:loading, class: 'spinner')
    div(:filters_area, class: 'd-none d-md-block col-sm-4 search-page-filter')
    ##filter by distance
    div(:distance_filter_area) { filters_area_element.div_element(class: 'radius') }
    button(:unit_selector) { distance_filter_area_element.button_element }
    div(:num_selector) { distance_filter_area_element.div_element(class: 'buttons-group') }
    ##filter by category
    div(:category_filter_area) { filters_area_element.div_element(class: 'search-filter', text: /job category/i) }
    button(:category_selector) { category_filter_area_element.button_element(class: 'radio-option btn', text: /#{@category}/) }
    ##filter by city
    div(:city_filter_area) { filters_area_element.div_element(class: 'search-filter', text: /cities/i) }
    button(:city_selector) { city_filter_area_element.button_element(class: 'checkbox-option btn', text: /#{@city}/) }
    button(:more) { city_filter_area_element.button_element(class: 'display-all-trigger btn', text: /more/i) }


    def search(info)
      search_area_element.when_present
      clear_search_area_elements.each { |element|
        element.click
      }

      if info.has_key?('tipo')
        search_type_element.when_present.value = info['tipo']
        if info.has_key?('tipo_autocomplete')
          sugestao_encontrada = false
          search_type_element.parent.div_element(class: 'tt-dataset tt-dataset-results').when_present
          search_type_tip_elements.each { |sugestao|
            if sugestao.text == info['tipo_autocomplete']
              sugestao.click
              sugestao_encontrada = true
            end
          }
          raise StandardError, "Sugestão ' #{info['tipo_autocomplete']}' não apresentada." unless sugestao_encontrada
        end
      end

      if info.has_key?('localizacao')
        search_location_element.when_present.value = info['localizacao']
      end

      search_button
      loading_element.when_not_present
    end

    def filter(filters)
      if filters.has_key?('distancia')
        filter_by_distance(filters['distancia'])
      end

      if filters.has_key?('categoria')
        filter_by_category(filters['categoria'])
      end

      if filters.has_key?('cidade')
        filter_by_city(filters['cidade'])
      end
    end

    def jobs_available?
      jobs_area_element.when_present
      if no_jobs_element.element.present?
        return false
      else
        return true
      end
    end

    private
    def filter_by_distance(filter)
      num, unidade = filter.split(" ")
      unidade.downcase!

      if unidade == "mi" && unit_selector_element.when_present.attribute('aria-label').to_s.match(/kilometers selected/i)
        unit_selector
      elsif unidade == "km" && unit_selector_element.when_present.attribute('aria-label').to_s.match(/miles selected/i)
        unit_selector
      end

      num_selector_element.button_element(text: "#{num}").when_present.click
      loading_element.when_not_present
    end

    def filter_by_category(filter)
      @category = filter
      category_filter_area_element.when_present
      category_selector
    end

    def filter_by_city(filter)
      @city = filter
      city_filter_area_element.when_present
      found = false
      while (!found)
        if city_selector_element.element.present?
          city_selector
          found = true
        end
        more
      end
    end
  end
end