(require '[babashka.process :refer [shell sh]])

(let [files (->> (sh "ls" "-1" "src")
              str/split-lines
              (filter #(str/ends-with? % ".scad")))]
  (doseq [filename files]
    (let [output-filename (str/replace filename ".scad" ".png")]
      (shell
        "openscad" (str "src/" filename)
        "-o" (str "images/" output-filename)))))
