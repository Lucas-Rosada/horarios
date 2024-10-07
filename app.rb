require 'sinatra'
require 'json'

def carregar_dados_onibus
  if File.exist?('dados_onibus.json')
    file = File.read('dados_onibus.json')
    JSON.parse(file)
  else
    []
  end
end

get '/' do
  @horario_filtrado = params['horario'] || ''
  
  @onibus = carregar_dados_onibus

  puts "Dados carregados: #{@onibus.inspect}"

  if @horario_filtrado != ''

    puts "Horário filtrado: #{@horario_filtrado}"

    @onibus = @onibus.select { |onibus| onibus['horario'] == @horario_filtrado }


    puts "Ônibus após filtragem: #{@onibus.inspect}"
  end

  erb :index  
end