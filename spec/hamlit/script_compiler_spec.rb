describe Hamlit::ScriptCompiler do
  describe '#call' do
    def assert_script_compile(before, after)
      result = described_class.new.call(before)
      expect(result).to eq(after)
    end

    it 'does not alter single-line script' do
      assert_script_compile(
        [:multi,
         [:dynamic, 'a']],
        [:multi,
         [:dynamic, 'a']],
      )
    end

    it 'compiles hamlit script ast into assigning' do
      assert_script_compile(
        [:haml,
         :script,
         'link_to user_path do',
         [:static, 'user']],
        [:multi,
         [:code, "_hamlit_compiler0 = link_to user_path do"],
         [:static, "user"],
         [:escape, false, [:dynamic, "_hamlit_compiler0"]]],
      )
    end

    it 'compiles multiple hamlit scripts' do
      assert_script_compile(
        [:multi,
         [:haml,
          :script,
          'link_to user_path do',
          [:static, 'user']],
         [:haml,
          :script,
          'link_to repo_path do',
          [:static, 'repo']]],
        [:multi,
         [:multi,
          [:code, "_hamlit_compiler0 = link_to user_path do"],
          [:static, "user"],
          [:escape, false, [:dynamic, "_hamlit_compiler0"]]],
         [:multi,
          [:code, "_hamlit_compiler1 = link_to repo_path do"],
          [:static, "repo"],
          [:escape, false, [:dynamic, "_hamlit_compiler1"]]]],
      )
    end
  end
end
