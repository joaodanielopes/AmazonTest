# encoding: utf-8
module Amazon

  class NovaConta
    def initialize
      @@LINK_CONTA       = $browser.element(id: 'nav-link-yourAccount', text: /Your Account/)
      @@LINK_CRIAR       = $browser.element(id: 'createAccountSubmit', text: /Create your Amazon account/)
      @@TEXT_NOME        = $browser.text_field(id: 'ap_customer_name')
      @@TEXT_EMAIL       = $browser.text_field(id: 'ap_email')
      @@TEXT_PASS        = $browser.text_field(id: 'ap_password')
      @@TEXT_PASS_CHECK  = $browser.text_field(id: 'ap_password_check')
      @@BUTTON_CONTINUAR = $browser.button(id: 'continue')
    end

    def criar(dados)
      @@LINK_CONTA.when_present.click
      @@LINK_CRIAR.when_present.click
      @@TEXT_NOME.when_present.set(dados['nome'])
      @@TEXT_EMAIL.set(dados['email'])
      @@TEXT_PASS.set(dados['password'])
      @@TEXT_PASS_CHECK.set(dados['password'])
      @@BUTTON_CONTINUAR.click
    end

    def campos_errados?
      $browser.divs(id: /alert/).each do |alert|
        return true if alert.visible? && @@BUTTON_EMAIL.present?
      end
      return false
    end
  end

  class Login
    def initialize
      @@LINK_CONTA    = $browser.element(id: 'nav-link-yourAccount', text: /Your Account/)
      @@TEXT_EMAIL    = $browser.text_field(id: 'ap_email')
      @@TEXT_PASS     = $browser.text_field(id: 'ap_password')
      @@BUTTON_ENTRAR = $browser.element(id: 'signInSubmit')
    end

    def login(dados)
      @@LINK_CONTA.when_present.click
      @@TEXT_EMAIL.when_present.set(dados['email'])
      @@TEXT_PASS.set(dados['password'])
      @@BUTTON_ENTRAR.click
    end

    def sucesso?
      return false unless @@TEXT_EMAIL.present? || @@TEXT_PASS.present? || !@@LINK_CONTA.present?
      return true
    end

    def apresenta_mensagem?(msg)
      $browser.divs(class: 'a-alert-content').each do |alert|
        return true if alert.visible? && alert.text == msg
      end
      return false
    end
  end

  class Pesquisa
    def initialize
      @@TEXT_PESQUISA    = $browser.text_field(id: 'twotabsearchtextbox')
      @@BUTTON_PESQUISA  = $browser.button(value: 'Go')
      @@LISTA_RESULTADOS = $browser.ul(id: 's-results-list-atf')

    end

    def pesquisa(texto)
      @@TEXT_PESQUISA.when_present.set(texto)
      @@BUTTON_PESQUISA.click
    end

    def existem_resultados?
      return true if @@LISTA_RESULTADOS.present?
      return false
    end

    def filtrar(filtro)
      f = false
      $browser.div(id: 'leftNav').checkboxes.each do |t|
        if t.parent.text.include?(filtro)
          t.click
          f = true
          break
        end
      end
      return f
    end

    def selecionar_resultado
      @@LISTA_RESULTADOS.when_present.link(class: /title/).click
    end
  end

  class Produto
    def initialize
      @@URL = $browser.url
    end

    def pesquiso_comentario_do_utilizador(utilizador)
      $browser.div(id: 'reviews-medley-footer').link(text: /see all \d+ reviews/i).when_present.click
      $browser.select_list(id: 'sort-order-dropdown').select_value("recent")

      b_next = $browser.ul(class: 'a-pagination').when_present.link(text: /Next/)
      while (b_next.present?)
        $browser.div(id: 'cm_cr-review_list').when_present.divs(class: 'a-section review').each do |review|
          return @review = review if review.link(class: 'a-profile').when_present.text == utilizador
        end
        b_next.click
      end
    end

    def inserir_comentario(comment)
      @review.link(text: /Comment/).click
      @review.textarea(id: /comment-text-area/).when_present.value=comment
      # @review.span(class: /submit-comment-button/, text: /comment/).button.click
    end

    def pesquiso_comentarios_por_estrela(estrela)
      $browser.table(id: 'histogramTable').when_present.link(title: /#{estrela} star/).click
    end

    def pesquiso_comentario_por_data(data)
      $browser.divs(id: /customer_review/).each { |review|
        return true if review.span(class: /review-date/).text == data
      }
      return false
    end

    def clicar_em_titulo(titulo)
      $browser.lis(id: /result/).each { |result|
        begin
          result.link(title: /#{titulo}/).click
          return true
        rescue Watir::Exception::UnknownObjectException
        end
      }
      return false
    end

    def descricao_contem_texto?(texto)
      return true if $browser.div(class: /synopsis/).when_present.text.include?(texto)
      return false
    end

    def capturar_trailer(duracao)
      $browser.link(href: /trailer/).when_present.click

      headless = Headless.new({ :display    => rand(10000),
                                :dimensions => "#{1680}x#{1050}x#{24}",
                                :video      => {
                                  :frame_rate => 12,
                                  :codec      => 'libx264',
                                  :provider   => 'ffmpeg' } })
      headless.start
      headless.video.start_capture
      sleep(duracao.to_i)
      headless.video.stop_and_save("./trailer.mp4")
      headless.destroy
    end
  end

  class ShopByDepartment
    def initialize
      @@DEPARTMENT_LIST = $browser.link(id: 'nav-link-shopall')
    end

    def selecionar(departamento, area)
      @@DEPARTMENT_LIST.when_present.hover
      $browser.div(id: 'nav-flyout-shopAll').span(class: /nav-hasPanel.*nav-item.*/, text: "#{departamento}").when_present.hover
      $browser.div(id: 'nav-flyout-shopAll').link(class: /nav-link.*nav-item.*/, text: "#{area}").when_present.click
    end

    def marca_existe?(marca)
      marcas = $browser.div(id: 'merchandised-content').div(class: /bxc-grid__container/, text: "Featured Brands")
      marcas.when_present.images.each { |image|
        return true if image.attribute_value('alt').to_s.match(/#{marca}/i)
      }
      return false
    end
  end
end
