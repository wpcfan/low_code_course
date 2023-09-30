package com.mooc.backend.entities;

import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Type;
import org.hibernate.proxy.HibernateProxy;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.SortedSet;
import java.util.TreeSet;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Cacheable
@org.hibernate.annotations.Cache(usage = org.hibernate.annotations.CacheConcurrencyStrategy.READ_WRITE)
@Entity
@Table(name = "mooc_page_layouts")
public class PageLayout extends Auditable implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String title;

    @Type(JsonType.class)
    @Column(columnDefinition = "json", nullable = false)
    private PageConfig config;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private PageStatus status = PageStatus.DRAFT;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private PageType pageType = PageType.Home;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private Platform platform = Platform.APP;

    /**
     * cascade = CascadeType.ALL 表示级联保存，删除，更新，刷新，合并等操作
     * orphanRemoval = true 表示删除孤儿数据，即没有任何关联的数据
     * mappedBy = "pageLayout" 表示由 PageBlock 中的 pageLayout 属性来维护关联关系
     * CascadeType 有以下几种：
     * CascadeType.PERSIST：级联新建，即保存一个父对象，同时保存子对象
     * CascadeType.REMOVE：级联删除，即删除一个父对象，同时删除子对象。它的删除是指将数据库中的关系删除，而不是将数据去除。
     * CascadeType.REFRESH：级联刷新，即重新查询数据库中的数据
     * CascadeType.MERGE：级联更新，即更新一个父对象，同时更新子对象
     * CascadeType.DETACH：级联脱管，即把一个对象从持久化状态变成游离状态。当一个对象被游离状态时，它就不会再跟持久化上下文中的对象保持同步了。
     * CascadeType.ALL：包含以上所有操作
     * <p>
     * CascadeType.REMOVE 和 orphanRemoval = true 的区别：
     * CascadeType.REMOVE 是指删除父对象的时候，同时删除子对象，但是子对象仍然存在于数据库中，只是没有了父对象的关联关系。
     * orphanRemoval = true 是指删除父对象的时候，同时删除子对象，而且子对象也会从数据库中删除。
     * <p>
     */
    @org.hibernate.annotations.Cache(usage = org.hibernate.annotations.CacheConcurrencyStrategy.READ_WRITE)
    @Builder.Default
    @OneToMany(mappedBy = "pageLayout", orphanRemoval = true, cascade = {CascadeType.ALL})
    private SortedSet<PageBlock> pageBlocks = new TreeSet<>();

    public void addPageBlock(PageBlock pageBlock) {
        pageBlocks.add(pageBlock);
        pageBlock.setPageLayout(this);
    }

    public void removePageBlock(PageBlock pageBlock) {
        pageBlocks.remove(pageBlock);
        pageBlock.setPageLayout(null);
    }

    @Override
    public final boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        Class<?> oEffectiveClass = o instanceof HibernateProxy ? ((HibernateProxy) o).getHibernateLazyInitializer().getPersistentClass() : o.getClass();
        Class<?> thisEffectiveClass = this instanceof HibernateProxy ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass() : this.getClass();
        if (thisEffectiveClass != oEffectiveClass) return false;
        PageLayout that = (PageLayout) o;
        return getId() != null && Objects.equals(getId(), that.getId());
    }

    @Override
    public final int hashCode() {
        return this instanceof HibernateProxy ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass().hashCode() : getClass().hashCode();
    }
}
