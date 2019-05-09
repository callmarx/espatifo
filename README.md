# Espatifô

Simples API-RESTful conversora de planilhas(CSV) em abstração relacional + não-relacional.

Surgiu com o propósito de mapear planilhas de cálculo (ou planilha eletrônica, vulgo _spreadsheet_ ) sob um contexto de atributo em entidades com pais, ou seja abstração de dados não-relacional sobre dados relacionais.

## Comece a usar



### Pré requisitos
Este projeto necessita de [Redis](https://redis.io/), [Sidekiq](https://github.com/mperham/sidekiq) e [PostgreSQL](https://www.postgresql.org/) (acima da versão 9.4 para uso de dados do tipo JSONB).

Instalações dos mesmos devem ser feita no seu sistema operacional (você leu LINUX!!!), com exceção do sidekiq, que é uma gema:
```
#no seu Gemfile
gem 'sidekiq'

#na pasta execute:
$ bundle install
```

####  Instalações no [Arch Linux](https://www.archlinux.org)
- [Arch linux Wiki Redis](https://wiki.archlinux.org/index.php/Redis)
- [Arch linux Wiki PostgreSQL](https://wiki.archlinux.org/index.php/PostgreSQL)

## Testes e T.D.D.

Somos novatos e inexperientes, o que não é uma desculpa para irresponsabilidade. [Sabe desenvolver bem em TDD?](#contribuindo)

## Desenvolvido sob

* [Ruby](https://www.ruby-lang.org/en/) - Linguagem
* [Ruby on Rails](https://rubyonrails.org/) - Framework
* [Arch linux - Kernel 5.0.11](https://www.archlinux.org/download/) - Sistema Operacional
* [XGH](http://sou.gohorseprocess.com.br/extreme-go-horse-xgh/) - Metodologia

## Seja um contribuidor

É OpenSource. Seguimos basicamente o [contrato social do Debian](https://www.debian.org/social_contract#guidelines) para colaborações.

Em breve incluiremos os passos para forks. Contato muitomelhornostrilhos@gmail.com

## Versão

Estamos apenas começando, mas já com planos para versão 3.141.5926.5359

## Autores

* **Eugenio Augusto Jimenes** - *Não foi eu* - [CallMarx](https://github.com/callmarx)
* **Tomaz Henrique Martins** - *Precisa comitar?* - [TTomAAz](https://github.com/ttomaaz)

## Contribuidores

* **Refinaria de Dados** - *Oh Bonitão...* - [RdD](https://refinariadedados.com.br/)


## License

[Licença LGPLv3](LICENCE.md)

## Agradecimentos

* [As vantagens de ser um bobo](bobo.txt)
* [Boleto Portões](https://www.youtube.com/watch?v=DOeYqmVNaZE)
