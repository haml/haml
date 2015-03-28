# describe Hamlit::Filters::Css do
#   describe '#compile' do
#     it 'renders css' do
#       assert_render(<<-HAML, <<-HTML)
#         :css
#           .foo {
#             width: 100px;
#           }
#       HAML
#         <style>
#           .foo {
#             width: 100px;
#           }
#         </style>
#       HTML
#     end
#
#     it 'parses string interpolation' do
#       assert_render(<<-'HAML', <<-HTML)
#         :css
#           .foo {
#             width: #{100 * 3}px;
#           }
#       HAML
#         <style>
#           .foo {
#             width: 300px;
#           }
#         </style>
#       HTML
#     end
#   end
# end
