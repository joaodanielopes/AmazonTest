# encoding: utf-8
module Amazon

  class NewAccount
    include PageObject

    link(:your_account, id: 'nav-link-yourAccount', text: /Your Account/)
    link(:create_new_account, id: 'createAccountSubmit', text: /Create your Amazon account/)
    text_field(:name, id: 'ap_customer_name')
    text_field(:email, id: 'ap_email')
    text_field(:password, id: 'ap_password')
    text_field(:password_check, id: 'ap_password_check')
    button(:create, id: 'continue')

    def create_account(info)
      your_account_element.when_present.click
      create_new_account_element.when_present.click
      name_element.when_present.value = info['nome']
      email_element.value             = info['email']
      password_element.value          = info['password']
      password_check_element.value    = info['password']

      create
    end

    def has_wrong_fields?
      $browser.divs(id: /alert/).each do |alert|
        return true if alert.visible?
      end
      return false
    end
  end

  class Login
    include PageObject

    link(:your_account, id: 'nav-link-yourAccount', text: /Your Account/)
    text_field(:email, id: 'ap_email')
    text_field(:password, id: 'ap_password')
    button(:sign_in, id: 'signInSubmit')

    def login(dados)
      your_account_element.when_present.click
      email_element.when_present.value    = dados['email']
      password_element.when_present.value =dados['password']
      sign_in
    end

    def has_sucess?
      return false unless email_element.element.present? || password_element.element.present? || !your_account_element.element.present?
      return true
    end

    def alert_presented?(msg)
      $browser.divs(class: 'a-alert-content').each do |alert|
        return true if alert.visible? && alert.text == msg
      end
      return false
    end
  end

  class Search
    include PageObject

    div(:search_area, id: 'nav-search')
    text_field(:search_for) { search_area_element.text_field_element(id: 'twotabsearchtextbox') }
    button(:search_btn) { search_area_element.button_element(value: 'Go') }

    ul(:results_list, id: 's-results-list-atf')
    link(:result) { results_list_element.link_element(class: /title-link/, title: "#{@text}") }
    div(:filter_area, id: 'leftNav')

    div(:loading, class: 'spinner')

    def search(texto)
      search_for_element.when_present.value = texto
      search_btn
      loading_element.when_not_present
    end

    def has_results?
      return true if results_list_element.element.present?
      return false
    end

    def filter(filter)
      f = false
      filter_area_element.when_present.checkbox_elements.each do |t|
        if t.parent.text.include?(filter)
          t.click
          f = true
          break
        end
      end
      return f
    end

    def select_first_result
      results_list_element.when_present.link_elements(class: /title-link/).first.click
    end

    def select(text)
      @text = text
      result_element.when_present.click
    end
  end

  class Produto
    include PageObject

    div(:synopsis, class: /synopsis/)
    link(:watch_trailer, href: /trailer/)

    div(:footer_area, id: 'reviews-medley-footer')
    link(:see_all_reviews) { footer_area_element.link_element(text: /see all \d+ reviews/i) }
    select_list(:sort_reviews, id: 'sort-order-dropdown')
    ul(:pagination, class: 'a-pagination')
    link(:next_page) { pagination_element.link_element(text: /Next/) }
    div(:review_list, id: 'cm_cr-review_list')
    divs(:reviews) { review_list_element.div_elements(class: 'a-section review') }
    table(:stars_filter_area, id: 'histogramTable')
    link(:stars_filter_selector) { stars_filter_area_element.link_element(title: /#{@stars} star/) }

    div(:loading, class: 'spinner')

    attr_accessor :review

    def search_review_by_user(user)
      see_all_reviews_element.when_present.click
      sort_reviews_element.when_present.select_value("recent")

      pagination_element.when_present
      while (next_page_element.element.present?)
        review_list_element.when_present
        reviews_elements.each do |review|
          if review.link_element(class: 'a-profile').when_present.text == user
            @review = review
            return 0
          end
        end
        next_page_element.click
        sleep(1)
        loading_element.when_not_present
      end
    end

    def insert_comment_to_review(comment)
      @review.span_element(css: 'span.a-size-base:nth-child(2) > span:nth-child(1)').when_present.click
      @review.text_area_element(id: /comment-text-area/).when_present.value = comment
      @review.span_element(class: /submit-comment-button/, text: /comment/).button_element
    end

    def filter_reviews_by_stars(stars)
      @stars=stars
      stars_filter_selector_element.when_present.click
      sleep(1)
      loading_element.when_not_present
    end

    def search_review_by_date(date)
      review_list_element.when_present
      reviews_elements.each { |review|
        return true if review.span_element(class: /review-date/).text == date
      }
      return false
    end

    def description_include?(text)
      return true if synopsis_element.when_present.text.include?(text)
      return false
    end

    def capture_trailer(duration)
      watch_trailer_element.when_present.click

      if $use_headless
        $browser.headless.video.start_capture unless $browser.headless.video.capture_running?
        n=0
        while (!$browser.headless.video.capture_running?)
          sleep(1)
          n = n.next
          raise(StandardError, "Video record doesn't start.") if n == 10
        end
        sleep(duration.to_i)
        $browser.headless.video.stop_and_save("./trailer.mp4")
      end
    end
  end

  class ShopByDepartment
    include PageObject

    link(:department_selector, id: 'nav-link-shopall')
    div(:department_area, id: 'nav-flyout-shopAll')
    span(:department) { department_area_element.span_element(class: /nav-hasPanel.*nav-item.*/, text: "#{@dep}") }
    span(:area) { department_area_element.link_element(class: /nav-link.*nav-item.*/, text: "#{@area}") }

    div(:merchandised_area, id: 'merchandised-content')
    div(:brands_area) { merchandised_area_element.div_element(class: /bxc-grid__container/, text: "Featured Brands") }

    def select_dep_and_area(dep, area)
      @dep  = dep
      @area = area
      department_selector_element.when_present.hover
      department_element.when_present.hover
      area_element.when_present.click
    end

    def brand_exists?(brand)
      brands_area_element.when_present.image_elements.each { |image|
        return true if image.attribute('alt').to_s.match(/#{brand}/i)
      }
      return false
    end
  end
end
