# esx_skill_school
This works with my previous scrips that use player skill/work points to speed up
work animations and calculate job grade. School is supposed to be an alternate
way of improving the char's job performance.

Run in SQL (you could theoretically already have the work one):
```
ALTER TABLE `users` ADD `work_experience` JSON NOT NULL DEFAULT '[]' AFTER `pincode`;
ALTER TABLE `users` ADD `skill_experience` JSON NOT NULL DEFAULT '[]' AFTER `work_experience`;
INSERT INTO `licenses` (`type`, `label`) VALUES ('ULSA', 'School Enrollment Receipt');
```

Depends on:
esx_license
ox_inventory
ultrahacx/ultra-voltlab