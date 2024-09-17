require "sketchup.rb"
require 'extensions.rb'

def estilos(nome_estilo)
    caminho_estilo = File.join(__dir__, 'Estilos', "#{nome_estilo}.style")
  
    return unless File.exist?(caminho_estilo)
  
    Sketchup.active_model.styles.add_style(caminho_estilo, true)
  rescue StandardError => e
    puts "Erro ao importar estilo '#{nome_estilo}': #{e.message}"
end

module Camadas_padrao 
    def self.activate_extension

        criar_camadas(
    
        '-2D-ESQUADRIA',
        '-2D-MOBILIARIO',
        '-2D-LEGENDA ESQUADRIA',
        '-2D-XREF',
        '-2D-LEGENDA AMBIENTE',
        

        '-ZOOM',
    
        '-ARQUITETURA-CHURRASQUEIRA',
        '-ARQUITETURA-ESCADA',
        '-ARQUITETURA-ESQUADRIA',
        '-ARQUITETURA-PAREDE',
        '-ARQUITETURA-PILAR',
        '-ARQUITETURA-PISO',
        '-ARQUITETURA-REVESTIMENTO',
        '-ARQUITETURA-VIGA',
    
        '-BANHEIRO-BACIA',
        '-BANHEIRO-BOX',
        '-BANHEIRO-CHUVEIRO',
        '-BANHEIRO-METAIS',
        '-BANHEIRO-NICHO BOX',
    
        '-CIVIL-CONSTRUIR',
        '-CIVIL-DEMOLIR',
    
        '-LOCAL-INTERIOR',
        '-LOCAL-EXTERIOR',
    
        '-COBERTURA-TELHADO',
        '-COBERTURA-CAIXA',
    
        '-OUTRO-ARVORE',
        '-OUTRO-CALCADA',
        '-OUTRO-RENDER',
        '-OUTRO-VEGETACAO',
    
        '-ILUMINACAO-HACHURA LUZ LINEAR',
        '-ILUMINACAO-LEGENDA',
        '-ILUMINACAO-LUMINARIA',
        '-ILUMINACAO-DECORATIVO MARCENARIA',
        '-ILUMINACAO-HACHURA LUZ MARCENARIA',
        '-ILUMINACAO-MARCENARIA',
        '-ILUMINACAO-SPOTLIGTH ENSCAPE',
        '-ILUMINACAO-SPOTLIGTH VRAY',
    
        '-INTERIORES-ADORNO',
        '-INTERIORES-CORTINA',
        '-INTERIORES-EXISTENTE',
        '-INTERIORES-MOBILIARIO',
        '-INTERIORES-QUADRO',
        '-INTERIORES-TAPETE',
    
        '-INTERIORES-ELETRO (AEREO)',
        '-INTERIORES-ELETRO (MARMORARIA)',
        '-INTERIORES-ELETRO (PISO)',
        '-INTERIORES-ELETRO (MARCENARIA)',
    
        '-MARCENARIA-AEREO',
        '-MARCENARIA-GERAL',
        '-MARCENARIA-PORTA',
    
        '-MARMORARIA-BANCADA',
        '-MARMORARIA-CUBA E METAIS',
    
        '-TECNICO-PONTO AR-COND',
        '-TECNICO-PONTO ESPELHO',
        '-TECNICO-PONTO HIDRO',
        '-TECNICO-PONTO ILUMINACAO',
    
        '-TECNICO-LEGENDA GUIA ILUMINACAO',
        '-TECNICO-LEGENDA AR-COND',
        '-TECNICO-LEGENDA COMPLETA',
        '-TECNICO-LEGENDA HIDRO',
        '-TECNICO-LEGENDA ILUMINACAO',
        '-TECNICO-LEGENDA OCULTAR',
        '-TECNICO-LEGENDA VISTA',
    
        '-RODAPE-ACABAMENTO',
        '-RODAPE-BASE ALVENARIA',
        '-RODAPE-MARMORARIA',
    
        '-TETO-FORRO',
        '-TETO-COMPLETO',
        '-TETO-LAJE',
    
        '-NIVEL-01',
        '-NIVEL-02',
        '-NIVEL-03',
        '-NIVEL-04' ) 
    
    end
    
    def self.criar_camadas(*nomes_camadas)
        model = Sketchup.active_model
        manager = model.layers

        # Cria e adiciona camadas
        nomes_camadas.each do |nome_camada|
            layer = manager.add_layer(nome_camada)
        end
    end

end 

module Cenas_zoom 

    def self.activate_extension
        
    modelo = Sketchup.active_model
    cenas = modelo.pages.to_a

    cenas.each do |cena|
        next if cena.name.downcase.include?('imag')

        modelo.pages.selected_page = cena

        sketchup_window = Sketchup.active_model.active_view
        sketchup_window.zoom_extents
        cena.update
    end

    # Exibir mensagem de conclusão
    UI.messagebox("Processo concluído! Todas as cenas foram atualizadas.")
    end

end 

module Cena_geral

    def self.activate_extension

        estilos('FM_VISTAS')
        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #adicionar cena
        name = "geral"
        model = Sketchup.active_model
        model.pages.add(name)

        eye = [-1000, -1000, 1000] #olha de canto na perspectiva
        target = [0, 0, 0]
        up = [0, 0, 1]

        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = true
        model.active_view.zoom_extents

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        #configurar estilo da cena
        cena.style = modelo.styles['FM VISTAS']
        
        model.active_view.zoom_extents
        cena.update
    end

end

module Cena_desenhar

    def self.activate_extension

        estilos('FM_VISTAS')
        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #adicionar cena
        name = "desenhar"
        model = Sketchup.active_model
        model.pages.add(name)

        eye = [-1000, -1000, 1000] #olha de canto na perspectiva
        target = [0, 0, 0]
        up = [0, 0, 1]

        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = true
        model.active_view.zoom_extents

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["TETO", "COBERTURA",'CIVIL']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        #configurar estilo da cena
        cena.style = modelo.styles['FM VISTAS']
        
        model.active_view.zoom_extents
        cena.update
    end

end

module Cena_etiquetar

    def self.activate_extension

        estilos('FM_VISTAS')
        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #adicionar cena
        name = "etiquetar"
        model = Sketchup.active_model
        model.pages.add(name)

        eye = [-1000, -1000, 1000] #olha de canto na perspectiva
        target = [0, 0, 0]
        up = [0, 0, 1]

        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = true
        model.active_view.zoom_extents

        #todas camadas invisiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = false }

        cena.update

        #configurar estilo da cena
        cena.style = modelo.styles['FM VISTAS']
        
        model.active_view.zoom_extents
        cena.update
    end

end

module Cena_planos 

    def self.activate_extension

        estilos('FM_PLANOS')
        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #adicionar cena
        name = "planos"
        model = Sketchup.active_model
        model.pages.add(name)

        eye = [-1000, -1000, 1000] #olha de canto na perspectiva
        target = [0, 0, 0]
        up = [0, 0, 1]

        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = true
        model.active_view.zoom_extents

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["TETO", "COBERTURA",'TECNICO','ADORNO','ILUMINACAO']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update


        #configurar estilo da cena
        cena.style = modelo.styles['FM PLANOS']
        cena.update

        model.active_view.zoom_extents
        cena.update
    end

end

module Cena_base

    def self.activate_extension

        estilos('FM_PLANTAS')
        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #adicionar plano de secão
        sp = entidades.add_section_plane([0, 0, 61.024], [0, 0, -1])
        sp.name = "#{name}"
        sp.activate

        #adicionar cena
        name = 'base'
        model = Sketchup.active_model
        model.pages.add(name)

        eye = [0, 0, 1000]  # Olha para baixo
        target = [0, 0, 0]
        up = [0, 1, 0]

        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = false
        model.active_view.zoom_extents

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["TETO", "COBERTURA",'ADORNO','ILUMINACAO','AEREO','TECNICO','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','OUTRO']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        #configurar estilo da cena
        cena.style = modelo.styles['FM PLANTAS']
        
        model.active_view.zoom_extents
        cena.update
    end

end

module Cena_arq 

    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar Base e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('arq')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ["TETO", "COBERTURA",'ADORNO','ILUMINACAO','AEREO','TECNICO','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','MARCENARIA','MARMORARIA','INTERIORES','INTERIORES','EXTERIOR','OUTRO']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            camadas_ocultas = ['-ARQUITETURA-PISO']
            camadas_ocultas.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = false if camada
            end
            cena.update

            #configurar estilo da cena
            model = Sketchup.active_model
            cena = Sketchup.active_model.pages.selected_page
            model.styles.selected_style = model.styles['FM PLANTAS']
            
            model.active_view.zoom_extents
            cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_mobi 

    def self.activate_extension

        estilos('FM_MOBILIARIO_LINHAS')
        estilos('FM_MOBILIARIO_OPACO')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == ''base'' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('mobi')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ['2D', 'ARQUITETURA', "TETO", "COBERTURA",'ADORNO','ILUMINACAO','AEREO','TECNICO','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','OUTRO']
            camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            #configurar estilo da cena
            model = Sketchup.active_model
            cena = Sketchup.active_model.pages.selected_page
            model.styles.selected_style = model.styles['FM MOBILIARIO LINHAS']
            
            model.active_view.zoom_extents
            cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_construir 

    def self.activate_extension

        estilos('FM_CONSTRUIR')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == ''base'' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('construir')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ['ARQUITETURA','BANHEIRO',"TETO", "COBERTURA",'ADORNO','ILUMINACAO','AEREO','TECNICO',
            'ESCALA','EXTERNO','XREF','RODAPE','MARCENARIA','MARMORARIA','INTERIORES','INTERIORES','EXTERIOR','OUTRO']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            camadas_ocultas = ['-ARQUITETURA-PISO','-CIVIL-DEMOLIR']
            camadas_ocultas.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = false if camada
            end
            cena.update

            #configurar estilo da cena
            model = Sketchup.active_model
            cena = Sketchup.active_model.pages.selected_page
            model.styles.selected_style = model.styles['FM CONSTRUIR']
            
            model.active_view.zoom_extents
            cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_demolir

    def self.activate_extension

        estilos('FM_DEMOLIR')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('demolir')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ['ARQUITETURA','BANHEIRO',"TETO", "COBERTURA",'ESCALA','ADORNO','ILUMINACAO','AEREO','TECNICO','ESCALA','EXTERNO','XREF','RODAPE','MARCENARIA','MARMORARIA','INTERIORES','INTERIORES','EXTERIOR','OUTRO']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            camadas_ocultas = ['-ARQUITETURA-PISO','-CIVIL-CONSTURIR']
            camadas_ocultas.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = false if camada
            end
            cena.update

            #configurar estilo da cena
            model = Sketchup.active_model
            cena = Sketchup.active_model.pages.selected_page
            model.styles.selected_style = model.styles['FM DEMOLIR']
            
            model.active_view.zoom_extents
            cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_layout

    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'layout' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('base')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ["TETO", "BANHEIRO","COBERTURA",'ADORNO','ILUMINACAO','AEREO','TECNICO','2D','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','MARCENARIA','MARMORARIA','INTERIORES','INTERIORES','EXTERIOR','OUTRO']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            camadas_ocultas = ['-ARQUITETURA-PISO']
            camadas_ocultas.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = false if camada
            end
            cena.update

            #configurar estilo da cena
            model = Sketchup.active_model
            cena = Sketchup.active_model.pages.selected_page
            model.styles.selected_style = model.styles['FM PLANTAS']
            
            model.active_view.zoom_extents
            cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_pontostec 

    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

        model.pages.selected_page = cena_base
            
        cena = Sketchup.active_model.pages.add('tecnico')

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["TETO", "COBERTURA",'ADORNO','ILUMINACAO','AEREO','EXTERNO','XREF','CIVIL','RODAPE','MARCENARIA','MARMORARIA','INTERIORES','INTERIORES','EXTERIOR','PONTO','BANHEIRO','2D','OUTRO']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        camadas_ocultas = ['-ARQUITETURA-PISO',"-TECNICO-LEGENDA VISTA"]
        camadas_ocultas.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = false if camada
        end
        cena.update

        camadas_aparentes = ['-TECNICO-LEGENDA ILUMINACAO','-2D-LEGENDA AMBIENTE']
        camadas_aparentes.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = true if camada
        end
        cena.update

        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM PLANTAS']
        cena.update
        model.active_view.zoom_extents
        cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_eletricos
    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

        model.pages.selected_page = cena_base
            
        cena = Sketchup.active_model.pages.add('eletrico')

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["TETO", "COBERTURA",'ADORNO','AEREO','EXTERNO','XREF','CIVIL','RODAPE','MARCENARIA',
        'MARMORARIA','INTERIORES','EXTERIOR','PONTO','BANHEIRO','2D','OUTRO','HACHURA','LUMINARIA','SPOTLIGTH']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        camadas_ocultas = ['-ARQUITETURA-PISO','-TECNICO-LEGENDA HIDRO','-TECNICO-LEGENDA VISTA']
        camadas_ocultas.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = false if camada
        end
        cena.update

        camadas_aparentes = ['-2D-LEGENDA AMBIENTE']
        camadas_aparentes.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = true if camada
        end
        cena.update

        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM PLANTAS']
        cena.update
        model.active_view.zoom_extents
        cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_hidro
    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

        model.pages.selected_page = cena_base
            
        cena = Sketchup.active_model.pages.add('hidro')

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["TETO", "COBERTURA",'ADORNO','ILUMINACAO','AEREO','EXTERNO','XREF','CIVIL','RODAPE',
        'MARCENARIA','MARMORARIA','INTERIORES','INTERIORES','EXTERIOR','PONTO','BANHEIRO','2D','OUTRO']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        camadas_ocultas = ['-ARQUITETURA-PISO','-TECNICO-GUIA','-TECNICO-LEGENDA INTERRUPTOR','-TECNICO-LEGENDA AR-COND',
        '-TECNICO-LEGENDA ELETRICA','-TECNICO-LEGENDA ILUMINACAO','-TECNICO-LEGENDA VISTA','-TECNICO-LEGENDA COMPLETA']
        camadas_ocultas.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = false if camada
        end
        cena.update

        camadas_aparentes = ['-2D-LEGENDA AMBIENTE']
        camadas_aparentes.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = true if camada
        end
        cena.update


        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM PLANTAS']
        cena.update
        model.active_view.zoom_extents
        cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_climatizacao 

    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

        model.pages.selected_page = cena_base
            
        cena = Sketchup.active_model.pages.add('clima')

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["TETO", "COBERTURA",'ADORNO','ILUMINACAO','AEREO','EXTERNO','XREF','CIVIL','RODAPE','MARCENARIA','MARMORARIA','INTERIORES','INTERIORES','EXTERIOR','PONTO','BANHEIRO','2D','OUTRO']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        camadas_ocultas = ['-ARQUITETURA-PISO','-TECNICO-GUIA','-TECNICO-LEGENDA HIDRO',
        '-TECNICO-LEGENDA ILUMINACAO','-TECNICO-LEGENDA INTERRUPTOR','-TECNICO-LEGENDA ELETRICA','-TECNICO-LEGENDA VISTA','-TECNICO-LEGENDA COMPLETA']
        camadas_ocultas.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = false if camada
        end
        cena.update

        camadas_aparentes = ['-2D-LEGENDA AMBIENTE']
        camadas_aparentes.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = true if camada
        end
        cena.update

        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM PLANTAS']
        cena.update
        model.active_view.zoom_extents
        cena.update
    
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_iluminacao 

    def self.activate_extension

        estilos('FM_VISTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

        model.pages.selected_page = cena_base
            
        cena = Sketchup.active_model.pages.add('iluminacao')

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ['LAJE','FORRO', "COBERTURA",'ADORNO','AEREO','EXTERNO','XREF','CIVIL','RODAPE','MARCENARIA','MARMORARIA',
        'INTERIORES','INTERIORES','EXTERIOR','PONTO','BANHEIRO','2D','SPOTLIGTH','OUTRO','ARQUITETURA']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        camadas_ocultas = ['-TECNICO-LEGENDA OCULTAR','-ARQUITETURA-PISO','-TECNICO-GUIA','-TECNICO-LEGENDA ELETRICA','-TECNICO-LEGENDA HIDRO','-TECNICO-LEGENDA VISTA',"-2D-LEGENDA AMBIENTE"]
        camadas_ocultas.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = false if camada
        end
        cena.update

        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM VISTAS']
      
        model.active_view.zoom_extents
        cena.update
    
        else
        UI.messagebox("Cena Base não encontrada.") 
        end

        
    end

end

module Cena_forro 

    def self.activate_extension

        estilos('FM_PLANTAS')
        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #adicionar plano de secão
        sp = entidades.add_section_plane([0, 0, 65], [0, 0, 1])
        sp.name = "#{name}"
        sp.activate

        #adicionar cena
        name = "forro"
        model = Sketchup.active_model
        model.pages.add(name)

        eye = [0, 0, -1000]  # Olha para cima
        target = [0, 0, 0]
        up = [0, 1, 0]

        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = false
        model.active_view.zoom_extents

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["COBERTURA",'ESCALA','ADORNO','AEREO','TECNICO','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','OUTRO','MARCENARIA','MARMORARIA','INTERIORES','BANHEIRO','SPOTLIGTH','HACHURA',]
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        camadas_ativas = ['-TECNICO-PONTO AR-COND',]
        camadas_ativas.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = true if camada
        end
        cena.update

        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM PLANTAS']
        
        model.active_view.zoom_extents
        cena.update
    end

end

module Cena_piso 

    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('reves')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ["TETO",'2D','BANHEIRO', "COBERTURA",'ESCALA','ADORNO','ILUMINACAO','AEREO','TECNICO','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','MARCENARIA','MARMORARIA','INTERIORES','EXTERIOR','OUTRO']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            camadas_visiveis = ['-RODAPE-ACABAMENTO']
            camadas_visiveis.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = true if camada
            end
            cena.update

            #configurar estilo da cena
            model.styles.selected_style = model.styles['FM PLANTAS']
            
            model.active_view.zoom_extents
            cena.update
    
        else
        UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_marcenaria

    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('marcenaria')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ["TETO",'BANHEIRO','2D', "COBERTURA",'ADORNO','ILUMINACAO','AEREO','TECNICO','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','INTERIORES','INTERIORES','EXTERIOR','OUTRO']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            camadas_visiveis = ['-ILUMINACAO-MARCENARIA','-ILUMINACAO-DECORATIVO MARCENARIA']
            camadas_visiveis.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = true if camada
            end
            cena.update

            #configurar estilo da cena
            model.styles.selected_style = model.styles['FM PLANTAS']
            
            model.active_view.zoom_extents
            cena.update
    
        else
        UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_marmoraria

    def self.activate_extension

        estilos('FM_PLANTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('marmoraria')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ["TETO",'BANHEIRO', "COBERTURA",'ESCALA','ADORNO','ILUMINACAO','AEREO','TECNICO','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','INTERIORES','INTERIORES','EXTERIOR','OUTRO','MARCENARIA']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            #configurar estilo da cena
            model.styles.selected_style = model.styles['FM PLANTAS']
            
            model.active_view.zoom_extents
            cena.update
    
        else
        UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Isolar_marcenaria

    def self.activate_extension

        estilos('FM_VISTAS')

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #duplicar layout e criar novo
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == 'base' }

        if cena_base

            model.pages.selected_page = cena_base
                
            page = Sketchup.active_model.pages.add('isolar')
            
            #todas camadas visiveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }

            cena.update

            grupos_ocultar = ["TETO","2D",'BANHEIRO', "COBERTURA",'ESCALA','ADORNO','TECNICO','ESCALA','EXTERNO','XREF','CIVIL','RODAPE','INTERIORES','ZOOM','INTERIORES','EXTERIOR','OUTRO','ARQUITETURA','SPOTLIGTH']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            camadas_ocultas = ['-ILUMINACAO-HACHURA LUZ LINEAR','-ILUMINACAO-LEGENDA','-ILUMINACAO-LUMINARIA']
            camadas_ocultas.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = false if camada
            end
            cena.update

            camadas_visivel = ['-INTERIORES-ELETRO (AEREO)','-INTERIORES-ELETRO (MARMORARIA)','-INTERIORES-ELETRO (PISO)','-INTERIORES-ELETRO (MARCENARIA)','-RODAPE-BASE ALVENARIA','-RODAPE-MARMORARIA',
            '-MARCENARIA-AEREO','-MARCENARIA-GERAL','-MARCENARIA-PORTA','-MARMORARIA-BANCADA','-MARMORARIA-CUBA E METAIS']
            camadas_visivel.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = true if camada
            end
            cena.update      

            #configurar estilo da cena
            model.styles.selected_style = model.styles['FM VISTAS']
            
            model.active_view.zoom_extents
            cena.update
    
        else
        UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Detalhes_botao

    def self.activate_extension

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        # Obtém a referência para o modelo ativo
        modelo = Sketchup.active_model

        # Obtém a referência para a seleção atual
        selecao = modelo.selection

        # Verifica se há um grupo ou componente selecionado
        if selecao.length == 1 && (selecao.first.is_a?(Sketchup::Group) || selecao.first.is_a?(Sketchup::ComponentInstance))
        # Obtém o grupo ou componente selecionado
        grupo_ou_componente = selecao.first

        # Obtém a referência para o contexto do modelo
        contexto_modelo = modelo.active_entities

        # Cria uma linha de 1 cm no eixo 0,0,0
        linha = contexto_modelo.add_line([0, 0, 0], [1.cm, 0, 0])

        # Cria um grupo com a linha e o grupo ou componente selecionado
        novo_grupo = contexto_modelo.add_group([linha, grupo_ou_componente])

        # Apaga a linha
        contexto_modelo.erase_entities(linha)

        # Define o prefixo para as camadas
        prefixo_camada = '-DET-'
        
        # Obtém todas as camadas existentes no modelo
        todas_camadas = modelo.layers.to_a
        
        # Encontra a próxima camada disponível no padrão 'DET-xx'
        numero_camada = (1..Float::INFINITY).find do |numero|
            nome_camada = "#{prefixo_camada}#{numero}"
            !todas_camadas.any? { |camada| camada.name == nome_camada }
        end

        # Cria a camada com o próximo número disponível
        nome_camada = "#{prefixo_camada}#{numero_camada}"
        nova_camada = modelo.layers.add(nome_camada)

        # Atribui o novo grupo à camada criada
        novo_grupo.layer = nova_camada

        # Atualiza a seleção para incluir o novo grupo
        selecao.clear
        selecao.add(novo_grupo)
        else
        puts 'Selecione um único grupo ou componente para executar este comando.'
        end

    end #self.activate_extension

end

module Cenas_detalhes_botao

    def self.activate_extension

        model = Sketchup.active_model
        estilos('FM_VISTAS')
        camadas = model.layers.to_a

        # Itera sobre cada camada
        camadas.each do |camada_atual|
            # Verifica se a camada começa com o prefixo DET-
            if camada_atual.name.start_with?('-DET-')
                # Remove o primeiro hífen e converte para minúsculas
                nome_cena = camada_atual.name[1..-1].downcase

                # Cria uma nova cena com o nome ajustado
                nova_cena = model.pages.add(nome_cena)

                eye = [-1000, -1000, 1000] #olha de canto na perspectiva
                target = [0, 0, 0]
                up = [0, 0, 1]

                model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
                model.active_view.camera.perspective = false
                model.active_view.zoom_extents

                # Define a visibilidade de todas as camadas como false (invisível)
                camadas.each { |c| c.visible = false }

                # Torna visível a camada atual (correspondente à cena criada)
                camada_atual.visible = true

                # Grupos a serem acessos
                grupos_visivel = ["MARCENARIA", "MARMORARIA"]
                # Isola as camadas que contêm os itens especificados no nome
                camadas.each do |c|
                    c.visible = true if grupos_visivel.any? { |item| c.name.include?(item) }
                end

                camadas_visivel = ['-INTERIORES-ELETRO (AEREO)','-INTERIORES-ELETRO (MARMORARIA)','-INTERIORES-ELETRO (PISO)','-INTERIORES-ELETRO (MARCENARIA)','-RODAPE-BASE ALVENARIA','-RODAPE-MARMORARIA',
                '-MARCENARIA-AEREO','-MARCENARIA-GERAL','-MARCENARIA-PORTA','-MARMORARIA-BANCADA','-MARMORARIA-CUBA E METAIS']
                 camadas_visivel.each do |nome_camada|
                camada = camadas.find { |c| c.name == nome_camada }
                camada.visible = true if camada
                end
            

                #configurar estilo da cena
                model.styles.selected_style = model.styles['FM VISTAS']
                
                model.active_view.zoom_extents

                # Atualiza a cena
                nova_cena.update
            end  
        end      
    end
end

module Cena_xref
    
    def self.activate_extension

        model = Sketchup.active_model
        #xref
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        
        grupos_ocultar = ["ARQUITETURA"]
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update
        
        model.active_view.zoom_extents
        cena.update

    end

end

module Cena_imagem_inicial

    def self.activate_extension

        estilos('FM_IMAGENS_VISTAS')
        estilos('FM_IMAGENS_CORTES')
        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #adicionar cena
        name = "imagem"
        model = Sketchup.active_model
        model.pages.add(name)

        eye = [-1000, -1000, 0] #olha de canto na perspectiva
        target = [0, 0, 0]
        up = [0, 0, 1]

        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = true

        camera = Sketchup.active_model.active_view.camera
        camera.fov = 50
        Sketchup.active_model.active_view.refresh

        model.active_view.zoom_extents

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ["ESCALA", "VRAY",'CIVIL','HACHURA','LEGENDA']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        camadas_ocultas = ['-TECNICO-PONTO HIDRO','-TECNICO-PONTO ILUMINACAO']
        camadas_ocultas.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = false if camada
        end
        cena.update

        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM IMAGENS VISTAS']
        
        model.active_view.zoom_extents
        cena.update
    end
  
end
  
module Cena_imagem

    def self.activate_extension

        # Obtém o modelo ativo
        model = Sketchup.active_model

        # Define o prefixo para o nome da cena
        prefixo = "imag "

        # Encontra o próximo número sequencial disponível
        numero_cena = (1..Float::INFINITY).find do |numero|
        nome_cena = "#{prefixo}#{format('%02d', numero)}"
        !model.pages.find { |cena| cena.name.downcase == nome_cena }
        end

        # Define o nome da cena com o número sequencial encontrado
        nome_cena = "#{prefixo}#{format('%02d', numero_cena)}"

        # Adiciona a cena com o nome sequencial ao modelo
        model.pages.add(nome_cena)

        # Atualiza a visualização para refletir a mudança
        Sketchup.active_model.active_view.refresh


    end

end

module Cena_cortes

    def self.activate_extension

        estilos('FM_PLANTAS')

        corte_abcd('a', [0, 40, 0], [0,1, 0])
        corte_abcd('b', [40, 0, 0], [1, 0, 0])
        corte_abcd('c', [0, 80, 0], [0, -1, 0])
        corte_abcd('d', [80, 0, 0], [-1, 0, 0])

    end

    def self.corte_abcd(name,position,direction)

        #reexibir tudo
        model = Sketchup.active_model
        entidades = model.entities

        entidades.each do |entidade|
            if entidade.hidden?
                entidade.hidden = false
            end
        end

        #adicionar plano de secão
        sp = entidades.add_section_plane(position, direction)
        sp.name = "#{name}"
        sp.activate

        #adicionar cena
        model = Sketchup.active_model
        model.pages.add(sp.name)

        eye = [direction[0] * -1000, direction[1] * -1000, direction[2] * -1000]
        target = [0, 0, 0]
        up = [0, 0, 1]

        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = false
        model.active_view.zoom_extents

        #todas camadas visiveis
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }

        cena.update

        grupos_ocultar = ['2D',"COBERTURA",'LINEAR','ESCALA','ADORNO','SPOTLIGTH','VISTA','ESCALA','EXTERNO','XREF','CIVIL','OUTRO','EXTERIOR','LEGENDA','GUIA']
        camadas.each do |camada|
            camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
        end
        cena.update

        camadas_ocultas = ['-TECNICO-PONTO ILUMINACAO','-2D-LEGENDA AMBIENTE']
        camadas_ocultas.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = false if camada
        end
        cena.update 

        camadas_visiveis = ['-ILUMINACAO-HACHURA LUZ LINEAR']
        camadas_visiveis.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = true if camada
        end
        cena.update

        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM PLANTAS']
        model.active_view.zoom_extents
        cena.update

        model = Sketchup.active_model
        entidades = model.entities
        cena_planos = model.pages.find { |cena| cena.name.downcase == 'planos' }
        model.pages.selected_page = cena_planos
    end

end

module Cena_cortes_tec

    def self.activate_extension

        # Definindo as letras para o loop
    for i in 'a'..'m'
        cena_existente = Sketchup.active_model.pages[i]
        if cena_existente
            corte_tec(i, "#{i} tec")
        end
    end

    end

    def self.corte_tec(corte, nome)
        model = Sketchup.active_model
        cena_base = model.pages.find { |cena| cena.name.downcase == corte }
    
        if cena_base
            model.pages.selected_page = cena_base
    
            page = Sketchup.active_model.pages.add(nome)
                
            # Todas camadas visíveis
            cena = Sketchup.active_model.pages.selected_page
            camadas = model.layers.to_a
            camadas.each { |camada| camada.visible = true }
            cena.update
    
            grupos_ocultar = ['2D','BANHEIRO',"HACHURA", "COBERTURA", 'ESCALA', 'XREF', 'CIVIL', 'OUTRO', '2D', 'SPOTLIGTH', 'EXTERNO', 'XREF', 'CIVIL', 'RODAPE', 'MARCENARIA', 'MARMORARIA', 'INTERIORES', 'INTERIORES']
            camadas.each do |camada|
                camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) }
            end
            cena.update

            camadas_visiveis = ['-ILUMINACAO-HACHURA LUZ LINEAR']
            camadas_visiveis.each do |nome_camada|
            camada = camadas.find { |c| c.name == nome_camada }
            camada.visible = true if camada
            end
            cena.update
    
            # Configurar estilo da cena
            model.styles.selected_style = model.styles['FM PLANTAS']
            
            model.active_view.zoom_extents
            cena.update
        else
            UI.messagebox("Cena Base não encontrada.") 
        end
    end

end

module Cena_corte_ind

    def self.activate_extension
        estilos('FM_PLANTAS')
    
        result = UI.inputbox(['Selecione uma opção'], ['Frente|Direita|Voltar|Esquerda'], ['Frente|Direita|Voltar|Esquerda'])
    
        # Verifica se houve uma seleção
        if result
            opcao_selecionada = result[0].split('|').first
            nome = UI.inputbox(['Digite um nome para a cena:'], [''])[0]
    
            # Mapeamento das opções para os cortes correspondentes
            case opcao_selecionada
            when 'Frente'
                corte_abcd('a', [0, 40, 0], [0, 1, 0], nome)
            when 'Direita'
                corte_abcd('b', [40, 0, 0], [1, 0, 0], nome)
            when 'Voltar'
                corte_abcd('c', [0, 80, 0], [0, -1, 0], nome)
            when 'Esquerda'
                corte_abcd('d', [80, 0, 0], [-1, 0, 0], nome)
            else
                UI.messagebox('Opção inválida.')
            end
        else
            UI.messagebox('Nenhuma opção selecionada.')
        end
    end
    
    def self.corte_abcd(name, position, direction, nome)
        model = Sketchup.active_model
        entidades = model.entities
    
        # Adicionar plano de seção
        sp = entidades.add_section_plane(position, direction)
        sp.name = nome
        sp.activate
    
        # Adicionar cena
        model.pages.add(sp.name)
    
        # Configurar a vista
        eye = [direction[0] * -1000, direction[1] * -1000, direction[2] * -1000]
        target = [0, 0, 0]
        up = [0, 0, 1]
    
        model.active_view.camera = Sketchup::Camera.new(eye, target, up, true)
        model.active_view.camera.perspective = false
        model.active_view.zoom_extents
    
        # Configurar camadas e estilos da cena
        cena = Sketchup.active_model.pages.selected_page
        camadas = model.layers.to_a
        camadas.each { |camada| camada.visible = true }
    
        # Ocultar camadas e estilos específicos
        grupos_ocultar = ['2D', 'COBERTURA','LINEAR','ESCALA', 'ADORNO', 'SPOTLIGTH', 'VISTA', 'ESCALA', 'EXTERNO', 'XREF', 'CIVIL', 'OUTRO', 'EXTERIOR', 'LEGENDA', 'GUIA']
        camadas.each { |camada| camada.visible = false if grupos_ocultar.any? { |item| camada.name.include?(item) } }
    
    
        model.styles.selected_style = model.styles['FM PLANTAS']
        model.active_view.zoom_extents
        cena.update

        model = Sketchup.active_model
        entidades = model.entities
        cena_planos = model.pages.find { |cena| cena.name.downcase == 'planos' }
        model.pages.selected_page = cena_planos

    end
end

module Cena_detalhamento

    def self.activate_extension

        model = Sketchup.active_model
        entities = model.active_entities
        selection = model.selection

        selection.invert

        model = Sketchup.active_model
        selection = model.selection

        selection.each do |entity|
        # Define a entidade como oculta
        entity.hidden = true
        end

        selection = model.selection

        selection.clear

        nome = UI.inputbox(['Digite um nome para a cena:'], [''])[0]

        nova_cena = model.pages.add(nome)

        #configurar estilo da cena
        model.styles.selected_style = model.styles['FM VISTAS']

        model.active_view.zoom_extents

        # Atualiza a cena
        nova_cena.update

        model = Sketchup.active_model
        model.active_path = nil

    end
end

########################################################################################## EXTENSÃO

def criar_botao_extension(toolbar, nome, ativar_metodo, icone, descricao)
    cmd_rename = UI::Command.new("FM - #{nome}") {
      ativar_metodo.call
    }
    cmd_rename.small_icon = File.join(__dir__, 'Imagens', "#{icone}.png")
    cmd_rename.large_icon = File.join(__dir__, 'Imagens', "#{icone}.png")
    cmd_rename.tooltip = nome
    cmd_rename.status_bar_text = descricao
  
    toolbar.add_item(cmd_rename)
end

toolbar = UI::Toolbar.new('FM - AGORA VAI')

criar_botao_extension(toolbar, 'Centralizar Tudo', Cenas_zoom.method(:activate_extension), 'zoom','Modelo centralizado e atualiza todas as cenas automaticamente, exceto imagens e cenas para render.')

criar_botao_extension(toolbar, 'Camadas Padrão', Camadas_padrao.method(:activate_extension), 'camada','Cria as camadas padrão para o arquivo.')

toolbar.add_separator

criar_botao_extension(toolbar, 'Cena Geral', Cena_geral.method(:activate_extension), 'geral','Crias as cena geral.')

criar_botao_extension(toolbar, 'Cena Desenhar', Cena_desenhar.method(:activate_extension), 'desenhar','Crias uma cena sem teto para melhor projetar no arquivo.')

criar_botao_extension(toolbar, 'Cena Etiquetar', Cena_etiquetar.method(:activate_extension), 'etiquetar','Crias as para etiquetar todo o modelo.')

criar_botao_extension(toolbar, 'Planos', Cena_planos.method(:activate_extension), 'plano','Cria a vista para visualizar os planos de secão.')

toolbar.add_separator

criar_botao_extension(toolbar, 'Cortes ABCD', Cena_cortes.method(:activate_extension), 'corte','Cria 4 planos de seção e suas vistas humanizadas.')

criar_botao_extension(toolbar, 'Cortes Técnicos', Cena_cortes_tec.method(:activate_extension), 'corte_tec','Cria 4 vistas tecnicas baseadas nos cortes já criados anteriormente.')

criar_botao_extension(toolbar, 'Cortes Individuais', Cena_corte_ind.method(:activate_extension), 'corte_ind','Cria 1 vista segundo a orientação escolhida.')

toolbar.add_separator

criar_botao_extension(toolbar, 'Layout', Cena_layout.method(:activate_extension), 'layout','Cria a planta de layout.')

criar_botao_extension(toolbar, 'Arquitetura', Cena_arq.method(:activate_extension), 'arq','Cria a planta de layout.')

criar_botao_extension(toolbar, 'Base Mobiliário', Cena_mobi.method(:activate_extension), 'mobi','Cria a planta de layout.')

toolbar.add_separator

criar_botao_extension(toolbar, 'Construir', Cena_construir.method(:activate_extension), 'construir','Cria a planta de construir, para usar com sobreposição no Layout.')

criar_botao_extension(toolbar, 'Demolir', Cena_demolir.method(:activate_extension), 'demolir','Cria a planta de demolir, para usar com sobreposição no Layout.')

toolbar.add_separator

criar_botao_extension(toolbar, 'Pontos Técnicos', Cena_pontostec.method(:activate_extension), 'pontostec','Cria a planta de pontos técnicos (eletrica, hidro e climatização juntos).')

criar_botao_extension(toolbar, 'Pontos Elétricos', Cena_eletricos.method(:activate_extension), 'eletrica','Cria somente a planta de pontos elétricos.')

criar_botao_extension(toolbar, 'Pontos Hidraulicos', Cena_hidro.method(:activate_extension), 'hidro','Cria somente a planta de pontos hidráulicos.')

criar_botao_extension(toolbar, 'Climatização', Cena_climatizacao.method(:activate_extension), 'clima','Cria a planta de pontos de ar-condicionado.')

toolbar.add_separator

criar_botao_extension(toolbar, 'Iluminação', Cena_iluminacao.method(:activate_extension), 'iluminacao','Cria a planta de iluminação. Usar base para sobrepor plantas no Layout.')

criar_botao_extension(toolbar, 'Forro', Cena_forro.method(:activate_extension), 'forro','Cria a planta de forro invertida.')

criar_botao_extension(toolbar, 'Revestimentos', Cena_piso.method(:activate_extension), 'revestimentos','Cria a planta de paginação de pisos.')

criar_botao_extension(toolbar, 'Marcenaria', Cena_marcenaria.method(:activate_extension), 'marcenaria','Cria a planta de marcenaria.')

criar_botao_extension(toolbar, 'Marmoraria', Cena_marmoraria.method(:activate_extension), 'marmoraria','Cria a planta de marmoraria.')

toolbar.add_separator

criar_botao_extension(toolbar, 'Isolar Marcenaria', Isolar_marcenaria.method(:activate_extension), 'isometrico','Cria a isometrica para detalhar a marcenaria.')

criar_botao_extension(toolbar, 'Detalhes Marcenaria', Detalhes_botao.method(:activate_extension), 'mais','Cria as etiquetas e coloca o grupo selecionado de marcenaria dentro da etiqueta.')

criar_botao_extension(toolbar, 'Cena dos Detalhes de Marcenaria', Cenas_detalhes_botao.method(:activate_extension), 'cena_detalhe','Cria as cenas de acordo com os detalhes de marcenaria criadas.')

criar_botao_extension(toolbar, 'Cena espefica de um grupo', Cena_detalhamento.method(:activate_extension), 'detalhe','Ao selecionar um grupo e vai ser isolado e criado automaticamente uma cena para ele')

toolbar.add_separator

criar_botao_extension(toolbar, 'Base', Cena_base.method(:activate_extension), 'base','Cria uma planta base sem informações para usar como sopreposição no Layout.')

criar_botao_extension(toolbar, 'Usar com Xref', Cena_xref.method(:activate_extension), 'xref','Transforma a cena selecionada em Xref para sobrepor dentro do Layout.')

toolbar.add_separator

criar_botao_extension(toolbar, 'Cena Imagens', Cena_imagem_inicial.method(:activate_extension), 'imagem','Abre uma cena para renderizar.')

criar_botao_extension(toolbar, 'Add Imagens', Cena_imagem.method(:activate_extension), 'ima','Abre uma cena para renderizar.')